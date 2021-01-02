import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:code_checker/checker.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/metrics/nesting_level/nesting_level_visitor.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

import 'anti_patterns/base_pattern.dart';
import 'anti_patterns_factory.dart';
import 'config/analysis_options.dart';
import 'config/config.dart';
import 'halstead_volume/halstead_volume_ast_visitor.dart';
import 'ignore_info.dart';
import 'lines_of_code/lines_with_code_ast_visitor.dart';
import 'metrics/cyclomatic_complexity/control_flow_ast_visitor.dart';
import 'metrics/cyclomatic_complexity/cyclomatic_config.dart';
import 'metrics_records_store.dart';
import 'models/component_record.dart';
import 'models/function_record.dart';
import 'rules_factory.dart';
import 'utils/metrics_analyzer_utils.dart';

final _featureSet = FeatureSet.fromEnableFlags([]);

/// Performs code quality analysis on specified files
/// See [MetricsAnalysisRunner] to get analysis info
class MetricsAnalyzer {
  final Iterable<Rule> _checkingCodeRules;
  final Iterable<BasePattern> _checkingAntiPatterns;
  final Iterable<Glob> _globalExclude;
  final Config _metricsConfig;
  final Iterable<Glob> _metricsExclude;
  final MetricsRecordsStore _store;
  final bool _useFastParser;

  MetricsAnalyzer(
    this._store, {
    AnalysisOptions options,
    Iterable<String> additionalExcludes = const [],
  })  : _checkingCodeRules =
            options?.rules != null ? getRulesById(options.rules) : [],
        _checkingAntiPatterns = options?.antiPatterns != null
            ? getPatternsById(options.antiPatterns)
            : [],
        _globalExclude = [
          ..._prepareExcludes(options?.excludePatterns),
          ..._prepareExcludes(additionalExcludes),
        ],
        _metricsConfig = options?.metricsConfig ?? const Config(),
        _metricsExclude = _prepareExcludes(options?.metricsExcludePatterns),
        _useFastParser = true;

  /// Return a future that will complete after static analysis done for files from [folders].
  Future<void> runAnalysis(Iterable<String> folders, String rootFolder) async {
    AnalysisContextCollection collection;
    if (!_useFastParser) {
      collection = AnalysisContextCollection(
        includedPaths: folders
            .map((path) => p.normalize(p.join(rootFolder, path)))
            .toList(),
        resourceProvider: PhysicalResourceProvider.INSTANCE,
      );
    }

    final filePaths = folders
        .expand((directory) => Glob('$directory/**.dart')
            .listSync(root: rootFolder, followLinks: false)
            .whereType<File>()
            .where((entity) => !_isExcluded(
                  p.relative(entity.path, from: rootFolder),
                  _globalExclude,
                ))
            .map((entity) => entity.path))
        .toList();

    for (final filePath in filePaths) {
      final normalized = p.normalize(p.absolute(filePath));

      ProcessedFile source;
      if (_useFastParser) {
        final result = parseFile(
          path: normalized,
          featureSet: _featureSet,
          throwIfDiagnostics: false,
        );

        source =
            ProcessedFile(Uri.parse(filePath), result.content, result.unit);
      } else {
        final analysisContext = collection.contextFor(normalized);
        final result =
            await analysisContext.currentSession.getResolvedUnit(normalized);

        source =
            ProcessedFile(Uri.parse(filePath), result.content, result.unit);
      }

      final visitor = ScopeVisitor();
      source.parsedContent.visitChildren(visitor);

      final lineInfo = source.parsedContent.lineInfo;

      _store.recordFile(filePath, rootFolder, (builder) {
        if (!_isExcluded(
          p.relative(filePath, from: rootFolder),
          _metricsExclude,
        )) {
          for (final component in visitor.components) {
            builder.recordComponent(
              component,
              ComponentRecord(
                firstLine: lineInfo
                    .getLocation(component
                        .declaration.firstTokenAfterCommentAndMetadata.offset)
                    .lineNumber,
                lastLine: lineInfo
                    .getLocation(component.declaration.endToken.end)
                    .lineNumber,
                methodsCount: visitor.functions
                    .where((function) =>
                        function.enclosingDeclaration == component)
                    .length,
              ),
            );
          }

          for (final function in visitor.functions) {
            final controlFlowAstVisitor =
                ControlFlowAstVisitor(defaultCyclomaticConfig, lineInfo);
            final halsteadVolumeAstVisitor = HalsteadVolumeAstVisitor();
            final linesWithCodeAstVisitor = LinesWithCodeAstVisitor(lineInfo);
            final nestingLevelVisitor =
                NestingLevelVisitor(function.declaration, lineInfo);

            function.declaration.visitChildren(controlFlowAstVisitor);
            function.declaration.visitChildren(halsteadVolumeAstVisitor);
            function.declaration.visitChildren(linesWithCodeAstVisitor);
            function.declaration.visitChildren(nestingLevelVisitor);

            builder.recordFunction(
              function,
              FunctionRecord(
                firstLine: lineInfo
                    .getLocation(function
                        .declaration.firstTokenAfterCommentAndMetadata.offset)
                    .lineNumber,
                lastLine: lineInfo
                    .getLocation(function.declaration.endToken.end)
                    .lineNumber,
                argumentsCount: getArgumentsCount(function),
                cyclomaticComplexityLines:
                    Map.unmodifiable(controlFlowAstVisitor.complexityLines),
                linesWithCode: linesWithCodeAstVisitor.linesWithCode,
                nestingLines: nestingLevelVisitor.nestingLines,
                operators: Map.unmodifiable(halsteadVolumeAstVisitor.operators),
                operands: Map.unmodifiable(halsteadVolumeAstVisitor.operands),
              ),
            );
          }
        }

        final ignores = IgnoreInfo.calculateIgnores(source.content, lineInfo);

        builder
          ..recordIssues(_checkOnCodeIssues(ignores, source))
          ..recordDesignIssues(
            _checkOnAntiPatterns(ignores, source, visitor.functions),
          );
      });
    }
  }

  Iterable<Issue> _checkOnCodeIssues(
    IgnoreInfo ignores,
    ProcessedFile source,
  ) =>
      _checkingCodeRules.where((rule) => !ignores.ignoreRule(rule.id)).expand(
            (rule) => rule.check(source).where((issue) =>
                !ignores.ignoredAt(issue.ruleId, issue.location.start.line)),
          );

  Iterable<Issue> _checkOnAntiPatterns(
    IgnoreInfo ignores,
    ProcessedFile source,
    Iterable<ScopedFunctionDeclaration> functions,
  ) =>
      _checkingAntiPatterns
          .where((pattern) => !ignores.ignoreRule(pattern.id))
          .expand((pattern) => pattern
              .check(source, functions, _metricsConfig)
              .where((issue) => !ignores.ignoredAt(
                    issue.ruleId,
                    issue.location.start.line,
                  )));
}

Iterable<Glob> _prepareExcludes(Iterable<String> patterns) =>
    patterns?.map((exclude) => Glob(exclude))?.toList() ?? [];

bool _isExcluded(String filePath, Iterable<Glob> excludes) =>
    excludes.any((exclude) => exclude.matches(filePath));
