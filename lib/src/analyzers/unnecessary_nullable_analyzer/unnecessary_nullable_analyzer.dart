import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
// ignore: implementation_imports
import 'package:analyzer/src/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart';
import 'package:source_span/source_span.dart';

import '../../config_builder/config_builder.dart';
import '../../config_builder/models/analysis_options.dart';
import '../../logger/logger.dart';
import '../../reporters/models/reporter.dart';
import '../../utils/analyzer_utils.dart';
import '../../utils/dart_types_utils.dart';
import '../../utils/flutter_types_utils.dart';
import '../../utils/suppression.dart';
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
  static const _ignoreName = 'unnecessary-nullable';

  final Logger? _logger;

  const UnnecessaryNullableAnalyzer([this._logger]);

  /// Returns a reporter for the given [name]. Use the reporter
  /// to convert analysis reports to console, JSON or other supported format.
  Reporter<UnnecessaryNullableFileReport, UnnecessaryNullableReportParams>?
      getReporter({
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
          _getAnalysisConfig(context, rootFolder, config);

      if (config.shouldPrintConfig) {
        _logger?.printConfig(unnecessaryNullableAnalysisConfig.toJson());
      }

      final filePaths = getFilePaths(
        folders,
        context,
        rootFolder,
        unnecessaryNullableAnalysisConfig.globalExcludes,
      );

      final analyzedFiles =
          filePaths.intersection(context.contextRoot.analyzedFiles().toSet());

      final contextsLength = collection.contexts.length;
      final filesLength = analyzedFiles.length;
      final updateMessage = contextsLength == 1
          ? 'Checking unnecessary nullable parameters for $filesLength file(s)'
          : 'Checking unnecessary nullable parameters for ${collection.contexts.indexOf(context) + 1}/$contextsLength contexts with $filesLength file(s)';
      _logger?.progress.update(updateMessage);

      for (final filePath in analyzedFiles) {
        _logger?.infoVerbose('Analyzing $filePath');

        final unit = await context.currentSession.getResolvedUnit(filePath);

        final invocationsUsage = _analyzeInvocationsUsage(unit);
        if (invocationsUsage != null) {
          _logger?.infoVerbose(
            'Found invocations: ${invocationsUsage.elements.length}',
          );

          invocationsUsages.merge(invocationsUsage);
        }

        if (!unnecessaryNullableAnalysisConfig.analyzerExcludedPatterns
            .any((pattern) => pattern.matches(filePath))) {
          _logger
              ?.infoVerbose('Found declarations: ${declarationsUsages.length}');

          declarationsUsages[filePath] = _analyzeDeclarationsUsage(unit);
        }
      }
    }

    if (!config.isMonorepo) {
      _logger?.infoVerbose(
        'Removing globally exported files with declarations from the analysis: ${invocationsUsages.exports.length}',
      );
      invocationsUsages.exports.forEach(declarationsUsages.remove);
    }

    return _getReports(invocationsUsages, declarationsUsages, rootFolder);
  }

  UnnecessaryNullableAnalysisConfig _getAnalysisConfig(
    AnalysisContext context,
    String rootFolder,
    UnnecessaryNullableConfig config,
  ) {
    final analysisOptions = analysisOptionsFromContext(context) ??
        analysisOptionsFromFilePath(rootFolder, context);

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
      final suppression = Suppression(unit.content, unit.lineInfo);
      final isSuppressed = suppression.isSuppressed(_ignoreName);
      if (isSuppressed) {
        return {};
      }

      final visitor = DeclarationsVisitor(suppression, _ignoreName);
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
          !_shouldIgnoreWidgetKey(parameter) &&
          !markedParameters.contains(parameter) &&
          isNullableType(parameter.declaredElement?.type),
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
          arg.name.label.name == parameter.name?.lexeme);
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

    final staticType = argument.staticType;

    final isNullable = argument is NullLiteral ||
        (staticType != null &&
            // ignore: deprecated_member_use
            (staticType.isDynamic || isNullableType(staticType)));

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

  bool _shouldIgnoreWidgetKey(FormalParameter parameter) {
    final closestDeclaration = parameter.parent?.parent;

    if (closestDeclaration is ConstructorDeclaration) {
      return parameter.name?.lexeme == 'key' &&
          isWidgetOrSubclass(closestDeclaration.declaredElement?.returnType);
    }

    return false;
  }
}
