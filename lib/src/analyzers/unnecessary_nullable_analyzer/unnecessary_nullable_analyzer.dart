import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
// ignore: implementation_imports
import 'package:analyzer/src/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart';
import 'package:source_span/source_span.dart';

import '../../config_builder/config_builder.dart';
import '../../config_builder/models/analysis_options.dart';
import '../../reporters/models/reporter.dart';
import '../../utils/analyzer_utils.dart';
import 'declarations_visitor.dart';
import 'invocations_visitor.dart';
import 'models/invocations_usage.dart';
import 'models/unnecessary_nullable_file_report.dart';
import 'models/unnecessary_nullable_issue.dart';
import 'reporters/reporter_factory.dart';
import 'reporters/unnecessary_nullable_report_params.dart';
import 'unnecessary_nullable_analysis_config.dart';
import 'unnecessary_nullable_config.dart';

/// The analyzer responsible for collecting unnecessary nullable parameters reports.
class UnnecessaryNullableAnalyzer {
  const UnnecessaryNullableAnalyzer();

  /// Returns a reporter for the given [name]. Use the reporter
  /// to convert analysis reports to console, JSON or other supported format.
  Reporter<UnnecessaryNullableFileReport, void,
      UnnecessaryNullableReportParams>? getReporter({
    required String name,
    required IOSink output,
  }) =>
      reporter(
        name: name,
        output: output,
      );

  /// Returns a list of unnecessary nullable parameters reports
  /// for analyzing all files in the given [folders].
  /// The analysis is configured with the [config].
  Future<Iterable<UnnecessaryNullableFileReport>> runCliAnalysis(
    Iterable<String> folders,
    String rootFolder,
    UnnecessaryNullableConfig config, {
    String? sdkPath,
  }) async {
    final collection =
        createAnalysisContextCollection(folders, rootFolder, sdkPath);

    final invocationsUsages = InvocationsUsage();
    final declarationsUsages = <String, DeclarationUsages>{};

    for (final context in collection.contexts) {
      final unnecessaryNullableAnalysisConfig =
          await _getAnalysisConfig(context, rootFolder, config);

      final filePaths = getFilePaths(
        folders,
        context,
        rootFolder,
        unnecessaryNullableAnalysisConfig.globalExcludes,
      );

      final analyzedFiles =
          filePaths.intersection(context.contextRoot.analyzedFiles().toSet());
      for (final filePath in analyzedFiles) {
        final unit = await context.currentSession.getResolvedUnit(filePath);

        final invocationsUsage = _analyzeInvocationsUsage(unit);
        if (invocationsUsage != null) {
          invocationsUsages.merge(invocationsUsage);
        }

        declarationsUsages[filePath] = _analyzeDeclarationsUsage(unit);
      }

      final notAnalyzedFiles = filePaths.difference(analyzedFiles);
      for (final filePath in notAnalyzedFiles) {
        if (unnecessaryNullableAnalysisConfig.analyzerExcludedPatterns
            .any((pattern) => pattern.matches(filePath))) {
          final unit = await resolveFile2(path: filePath);

          final invocationsUsage = _analyzeInvocationsUsage(unit);
          if (invocationsUsage != null) {
            invocationsUsages.merge(invocationsUsage);
          }
        }
      }
    }

    if (!config.isMonorepo) {
      invocationsUsages.exports.forEach(declarationsUsages.remove);
    }

    return _getReports(invocationsUsages, declarationsUsages, rootFolder);
  }

  Future<UnnecessaryNullableAnalysisConfig> _getAnalysisConfig(
    AnalysisContext context,
    String rootFolder,
    UnnecessaryNullableConfig config,
  ) async {
    final analysisOptions = await analysisOptionsFromContext(context) ??
        await analysisOptionsFromFilePath(rootFolder);

    final contextConfig =
        ConfigBuilder.getUnnecessaryNullableConfigFromOption(analysisOptions)
            .merge(config);

    return ConfigBuilder.getUnnecessaryNullableConfig(
      contextConfig,
      rootFolder,
    );
  }

  InvocationsUsage? _analyzeInvocationsUsage(SomeResolvedUnitResult unit) {
    if (unit is ResolvedUnitResult) {
      final visitor = InvocationsVisitor();
      unit.unit.visitChildren(visitor);

      return visitor.invocationsUsages;
    }

    return null;
  }

  DeclarationUsages _analyzeDeclarationsUsage(SomeResolvedUnitResult unit) {
    if (unit is ResolvedUnitResult) {
      final visitor = DeclarationsVisitor();
      unit.unit.visitChildren(visitor);

      return visitor.declarations;
    }

    return {};
  }

  Iterable<UnnecessaryNullableFileReport> _getReports(
    InvocationsUsage invocationsUsage,
    Map<String, DeclarationUsages> declarationsByPath,
    String rootFolder,
  ) {
    final unnecessaryNullableReports = <UnnecessaryNullableFileReport>[];

    declarationsByPath.forEach((path, elements) {
      final issues = <UnnecessaryNullableIssue>[];

      for (final entry in elements.entries) {
        final issue = _getUnnecessaryNullableIssues(
          invocationsUsage,
          entry.key,
          entry.value,
        );
        if (issue != null) {
          issues.add(issue);
        }
      }

      final relativePath = relative(path, from: rootFolder);

      if (issues.isNotEmpty) {
        unnecessaryNullableReports.add(UnnecessaryNullableFileReport(
          path: path,
          relativePath: relativePath,
          issues: issues,
        ));
      }
    });

    return unnecessaryNullableReports;
  }

  UnnecessaryNullableIssue? _getUnnecessaryNullableIssues(
    InvocationsUsage invocationsUsage,
    Element element,
    Iterable<FormalParameter> parameters,
  ) {
    final usages = invocationsUsage.elements[element];
    final unit = element.thisOrAncestorOfType<CompilationUnitElement>();
    if (usages == null || unit == null) {
      return null;
    }

    final markedParameters = <FormalParameter>{};

    final notNamedParameters =
        parameters.where((parameter) => !parameter.isNamed).toList();

    for (final usage in usages) {
      final namedArguments =
          usage.arguments.whereType<NamedExpression>().toList();
      final notNamedArguments =
          usage.arguments.whereNot((arg) => arg is NamedExpression).toList();

      for (final parameter in parameters) {
        final relatedArgument = _findRelatedArgument(
          parameter,
          namedArguments,
          notNamedArguments,
          notNamedParameters,
        );

        if (relatedArgument == null ||
            _shouldMarkParameterAsNullable(relatedArgument)) {
          markedParameters.add(parameter);
        }
      }
    }

    final unnecessaryNullable = parameters.where(
      (parameter) =>
          !markedParameters.contains(parameter) &&
          parameter.declaredElement?.type.nullabilitySuffix ==
              NullabilitySuffix.question,
    );

    if (unnecessaryNullable.isEmpty) {
      return null;
    }

    return _createUnnecessaryNullableIssue(
      element as ElementImpl,
      unit,
      unnecessaryNullable,
    );
  }

  Expression? _findRelatedArgument(
    FormalParameter parameter,
    List<Expression> namedArguments,
    List<Expression> notNamedArguments,
    List<FormalParameter> notNamedParameters,
  ) {
    if (parameter.isNamed) {
      return namedArguments.firstWhereOrNull((arg) =>
          arg is NamedExpression &&
          arg.name.label.name == parameter.identifier?.name);
    }

    final parameterIndex = notNamedParameters.indexOf(parameter);

    return notNamedArguments
        .whereNot((element) => element is NamedExpression)
        .firstWhereIndexedOrNull((index, _) => index == parameterIndex);
  }

  bool _shouldMarkParameterAsNullable(Expression argument) {
    if (argument is NamedExpression) {
      return _shouldMarkParameterAsNullable(argument.expression);
    }

    final isNullable = argument is NullLiteral ||
        argument.staticType?.nullabilitySuffix == NullabilitySuffix.question;

    return isNullable;
  }

  UnnecessaryNullableIssue _createUnnecessaryNullableIssue(
    ElementImpl element,
    CompilationUnitElement unit,
    Iterable<FormalParameter> parameters,
  ) {
    final offset = element.codeOffset!;
    final lineInfo = unit.lineInfo;
    final offsetLocation = lineInfo.getLocation(offset);

    final sourceUrl = element.source!.uri;

    return UnnecessaryNullableIssue(
      declarationName: element.displayName,
      declarationType: element.kind.displayName,
      parameters: parameters.map((parameter) => parameter.toString()),
      location: SourceLocation(
        offset,
        sourceUrl: sourceUrl,
        line: offsetLocation.lineNumber,
        column: offsetLocation.columnNumber,
      ),
    );
  }
}
