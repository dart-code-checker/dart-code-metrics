import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/element/element.dart';
// ignore: implementation_imports
import 'package:analyzer/src/dart/element/element.dart';
import 'package:path/path.dart';
import 'package:source_span/source_span.dart';

import '../../config_builder/config_builder.dart';
import '../../config_builder/models/analysis_options.dart';
import '../../reporters/models/reporter.dart';
import '../../utils/analyzer_utils.dart';
import '../../utils/file_utils.dart';
import 'models/unused_localization_file_report.dart';
import 'reporters/reporter_factory.dart';
import 'unused_localization_config.dart';
import 'unused_localization_visitor.dart';

class UnusedLocalizationAnalyzer {
  const UnusedLocalizationAnalyzer();

  Reporter? getReporter({
    required String name,
    required IOSink output,
  }) =>
      reporter(
        name: name,
        output: output,
      );

  Future<Iterable<UnusedLocalizationFileReport>> runCliAnalysis(
    Iterable<String> folders,
    String rootFolder,
    UnusedLocalizationConfig config,
  ) async {
    final collection = createAnalysisContextCollection(folders, rootFolder);

    final localizationUsages = <ClassElement, Set<String>>{};

    for (final context in collection.contexts) {
      final analysisOptions = await analysisOptionsFromContext(context) ??
          await analysisOptionsFromFilePath(rootFolder);

      final contextConfig =
          ConfigBuilder.getUnusedLocalizationConfigFromOption(analysisOptions)
              .merge(config);
      final unusedLocalizationAnalysisConfig =
          ConfigBuilder.getUnusedLocalizationConfig(contextConfig, rootFolder);

      final contextFolders = folders
          .where((path) => normalize(join(rootFolder, path))
              .startsWith(context.contextRoot.root.path))
          .toList();

      final filePaths = extractDartFilesFromFolders(
        contextFolders,
        rootFolder,
        unusedLocalizationAnalysisConfig.globalExcludes,
      );

      final analyzedFiles =
          filePaths.intersection(context.contextRoot.analyzedFiles().toSet());

      for (final filePath in analyzedFiles) {
        final unit = await context.currentSession.getResolvedUnit(filePath);

        _analyzeFile(unit, unusedLocalizationAnalysisConfig.classPattern)
            .forEach((classElement, usages) {
          localizationUsages.update(
            classElement,
            (value) => value..addAll(usages),
            ifAbsent: () => usages,
          );
        });
      }

      final notAnalyzedFiles = filePaths.difference(analyzedFiles);

      for (final filePath in notAnalyzedFiles) {
        if (unusedLocalizationAnalysisConfig.analyzerExcludedPatterns
            .any((pattern) => pattern.matches(filePath))) {
          final unit = await resolveFile2(path: filePath);

          _analyzeFile(unit, unusedLocalizationAnalysisConfig.classPattern)
              .forEach((classElement, usages) {
            localizationUsages.update(
              classElement,
              (value) => value..addAll(usages),
              ifAbsent: () => usages,
            );
          });
        }
      }
    }

    return _checkUnusedL10n(localizationUsages, rootFolder);
  }

  Map<ClassElement, Set<String>> _analyzeFile(
    SomeResolvedUnitResult unit,
    RegExp classPattern,
  ) {
    if (unit is ResolvedUnitResult) {
      final visitor = UnusedLocalizationVisitor(classPattern);
      unit.unit.visitChildren(visitor);

      return visitor.invocations;
    }

    return {};
  }

  Iterable<UnusedLocalizationFileReport> _checkUnusedL10n(
    Map<ClassElement, Set<String>> localizationUsages,
    String rootFolder,
  ) {
    final unusedLocalizationIssues = <UnusedLocalizationFileReport>[];

    localizationUsages.forEach((classElement, usages) {
      final unit =
          classElement.thisOrAncestorOfType<CompilationUnitElementImpl>();
      if (unit != null) {
        final lineInfo = unit.lineInfo;
        if (lineInfo != null) {
          final accessorSourceSpans =
              _getUnusedAccessors(classElement, usages, unit);
          final methodSourceSpans =
              _getUnusedMethods(classElement, usages, unit);

          final filePath = unit.source.uri.path;
          final relativePath = relative(filePath, from: rootFolder);

          unusedLocalizationIssues.add(
            UnusedLocalizationFileReport(
              path: filePath,
              relativePath: relativePath,
              className: classElement.name,
              unusedMembersLocation: [
                ...accessorSourceSpans,
                ...methodSourceSpans,
              ],
            ),
          );
        }
      }
    });

    return unusedLocalizationIssues;
  }

  Iterable<SourceSpan> _getUnusedAccessors(
    ClassElement classElement,
    Set<String> usages,
    CompilationUnitElementImpl unit,
  ) {
    final unusedAccessors = classElement.accessors
        .where((field) => !usages.contains(field.name) && !field.isSynthetic)
        .toList();

    return unusedAccessors
        .map((accessor) => _createSourceSpan(accessor as ElementImpl, unit))
        .toList();
  }

  Iterable<SourceSpan> _getUnusedMethods(
    ClassElement classElement,
    Set<String> usages,
    CompilationUnitElementImpl unit,
  ) {
    final unusedMethods = classElement.methods
        .where(
          (method) => !usages.contains(method.name) && !method.isSynthetic,
        )
        .toList();

    return unusedMethods
        .map((method) => _createSourceSpan(method as ElementImpl, unit))
        .toList();
  }

  SourceSpan _createSourceSpan(
    ElementImpl element,
    CompilationUnitElementImpl unit,
  ) {
    final offset = element.codeOffset!;
    final end = offset + element.codeLength!;

    final lineInfo = unit.lineInfo!;
    final offsetLocation = lineInfo.getLocation(offset);
    final endLocation = lineInfo.getLocation(end);

    final sourceUrl = element.source!.uri;

    return SourceSpan(
      SourceLocation(
        offset,
        sourceUrl: sourceUrl,
        line: offsetLocation.lineNumber,
        column: offsetLocation.columnNumber,
      ),
      SourceLocation(
        end,
        sourceUrl: sourceUrl,
        line: endLocation.lineNumber,
        column: endLocation.columnNumber,
      ),
      unit.sourceContent!.substring(offset, end),
    );
  }
}
