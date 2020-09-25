import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

import 'analysis_options.dart';
import 'anti_patterns/base_pattern.dart';
import 'anti_patterns_factory.dart';
import 'halstead_volume/halstead_volume_ast_visitor.dart';
import 'ignore_info.dart';
import 'lines_of_code/lines_with_code_ast_visitor.dart';
import 'metrics/cyclomatic_complexity/control_flow_ast_visitor.dart';
import 'metrics/cyclomatic_complexity/cyclomatic_config.dart';
import 'metrics_records_store.dart';
import 'models/component_record.dart';
import 'models/config.dart';
import 'models/design_issue.dart';
import 'models/function_record.dart';
import 'models/source.dart';
import 'rules/base_rule.dart';
import 'rules_factory.dart';
import 'scope_ast_visitor.dart';
import 'utils/metrics_analyzer_utils.dart';

/// Performs code quality analysis on specified files
/// See [MetricsAnalysisRunner] to get analysis info
class MetricsAnalyzer {
  final Iterable<BaseRule> _checkingCodeRules;
  final Iterable<BasePattern> _checkingAntiPatterns;
  final Iterable<Glob> _globalExclude;
  final Config _metricsConfig;
  final Iterable<Glob> _metricsExclude;
  final MetricsRecordsStore _store;

  MetricsAnalyzer(
    this._store, {
    AnalysisOptions options,
    Iterable<String> addintionalExcludes = const [],
  })  : _checkingCodeRules =
            options?.rules != null ? getRulesById(options.rules) : [],
        _checkingAntiPatterns = options?.antiPatterns != null
            ? getPatternsById(options.antiPatterns)
            : [],
        _globalExclude = [
          ..._prepareExcludes(options?.excludePatterns),
          ..._prepareExcludes(addintionalExcludes),
        ],
        _metricsConfig = options?.metricsConfig ?? const Config(),
        _metricsExclude = _prepareExcludes(options?.metricsExcludePatterns);

  Future<void> runAnalysis(Iterable<String> folders, String rootFolder) async {
    final collection = AnalysisContextCollection(
      includedPaths:
          folders.map((path) => p.normalize(p.join(rootFolder, path))).toList(),
      resourceProvider: PhysicalResourceProvider.INSTANCE,
    );

    final filePaths = folders
        .expand((directory) => Glob('$directory/**.dart')
            .listSync(root: rootFolder, followLinks: false)
            .whereType<File>()
            .where((entity) => !_isExcluded(
                p.relative(entity.path, from: rootFolder), _globalExclude))
            .map((entity) => entity.path))
        .toList();

    for (final filePath in filePaths) {
      final normalized = p.normalize(p.absolute(filePath));
      final analysisContext = collection.contextFor(normalized);
      final parseResult =
          await analysisContext.currentSession.getResolvedUnit(normalized);

      final visitor = ScopeAstVisitor();
      parseResult.unit.visitChildren(visitor);

      final lineInfo = parseResult.lineInfo;

      _store.recordFile(filePath, rootFolder, (builder) {
        if (!_isExcluded(
            p.relative(filePath, from: rootFolder), _metricsExclude)) {
          for (final component in visitor.components) {
            builder.recordComponent(
                component,
                ComponentRecord(
                    firstLine: lineInfo
                        .getLocation(component.declaration
                            .firstTokenAfterCommentAndMetadata.offset)
                        .lineNumber,
                    lastLine: lineInfo
                        .getLocation(component.declaration.endToken.end)
                        .lineNumber,
                    methodsCount: visitor.functions
                        .where((function) =>
                            function.enclosingDeclaration ==
                            component.declaration)
                        .length));
          }

          for (final function in visitor.functions) {
            final controlFlowAstVisitor =
                ControlFlowAstVisitor(defaultCyclomaticConfig, lineInfo);
            final linesWithCodeAstVisitor = LinesWithCodeAstVisitor(lineInfo);
            final halsteadVolumeAstVisitor = HalsteadVolumeAstVisitor();

            function.declaration.visitChildren(controlFlowAstVisitor);
            function.declaration.visitChildren(linesWithCodeAstVisitor);
            function.declaration.visitChildren(halsteadVolumeAstVisitor);

            builder.recordFunction(
                function,
                FunctionRecord(
                    firstLine: lineInfo
                        .getLocation(function.declaration
                            .firstTokenAfterCommentAndMetadata.offset)
                        .lineNumber,
                    lastLine: lineInfo
                        .getLocation(function.declaration.endToken.end)
                        .lineNumber,
                    argumentsCount: getArgumentsCount(function),
                    cyclomaticComplexityLines:
                        Map.unmodifiable(controlFlowAstVisitor.complexityLines),
                    linesWithCode: linesWithCodeAstVisitor.linesWithCode,
                    operators:
                        Map.unmodifiable(halsteadVolumeAstVisitor.operators),
                    operands:
                        Map.unmodifiable(halsteadVolumeAstVisitor.operands)));
          }
        }

        final ignores =
            IgnoreInfo.calculateIgnores(parseResult.content, lineInfo);

        final filePathUri = Uri.parse(filePath);

        builder
          ..recordIssues(_checkingCodeRules
              .where((rule) => !ignores.ignoreRule(rule.id))
              .expand((rule) => rule
                  .check(parseResult.unit, filePathUri, parseResult.content)
                  .where((issue) => !ignores.ignoredAt(
                      issue.ruleId, issue.sourceSpan.start.line))))
          ..recordDesignIssues(
              _checkOnAntiPatterns(ignores, parseResult, filePathUri));
      });
    }
  }

  Iterable<DesignIssue> _checkOnAntiPatterns(IgnoreInfo ignores,
          ResolvedUnitResult analysisResult, Uri sourceUri) =>
      _checkingAntiPatterns
          .where((pattern) => !ignores.ignoreRule(pattern.id))
          .expand((pattern) => pattern
              .check(
                  Source(
                      sourceUri, analysisResult.content, analysisResult.unit),
                  _metricsConfig)
              .where((issue) => !ignores.ignoredAt(
                  issue.patternId, issue.sourceSpan.start.line)));
}

Iterable<Glob> _prepareExcludes(Iterable<String> patterns) =>
    patterns?.map((exclude) => Glob(exclude))?.toList() ?? [];

bool _isExcluded(String filePath, Iterable<Glob> excludes) =>
    excludes.any((exclude) => exclude.matches(filePath));
