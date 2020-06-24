import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/halstead_volume/halstead_volume_ast_visitor.dart';
import 'package:dart_code_metrics/src/ignore_info.dart';
import 'package:dart_code_metrics/src/lines_of_code/function_body_ast_visitor.dart';
import 'package:dart_code_metrics/src/metrics_analysis_recorder.dart';
import 'package:dart_code_metrics/src/metrics_analyzer_utils.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/rules/base_rule.dart';
import 'package:dart_code_metrics/src/scope_ast_visitor.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

import 'analysis_options.dart';
import 'metrics/cyclomatic_complexity/control_flow_ast_visitor.dart';
import 'metrics/cyclomatic_complexity/cyclomatic_config.dart';
import 'rules_factory.dart';

/// Performs code quality analysis on specified files
/// See [MetricsAnalysisRunner] to get analysis info
class MetricsAnalyzer {
  final Iterable<BaseRule> _checkingCodeRules;
  final Iterable<Glob> _metricsExclude;
  final MetricsAnalysisRecorder _recorder;

  MetricsAnalyzer(
    this._recorder, {
    AnalysisOptions options,
  })  : _checkingCodeRules = getRulesById(options?.rulesNames ?? []),
        _metricsExclude = options?.metricsExcludePatterns
                ?.map((exclude) => Glob(exclude))
                ?.toList() ??
            [];

  void runAnalysis(String filePath, String rootFolder) {
    final relativeFilePath = p.relative(filePath, from: rootFolder);
    if (_metricsExclude.any((excluded) => excluded.matches(relativeFilePath))) {
      return;
    }

    final visitor = ScopeAstVisitor();
    final parseResult = parseFile(
        path: p.normalize(p.absolute(filePath)),
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false);
    parseResult.unit.visitChildren(visitor);

    if (visitor.functions.isNotEmpty) {
      _recorder.startRecordFile(filePath, rootFolder);

      for (final function in visitor.functions) {
        final controlFlowAstVisitor = ControlFlowAstVisitor(
            defaultCyclomaticConfig, parseResult.lineInfo);
        final functionBodyAstVisitor =
            FunctionBodyAstVisitor(parseResult.lineInfo);
        final halsteadVolumeAstVisitor = HalsteadVolumeAstVisitor();

        function.declaration.visitChildren(controlFlowAstVisitor);
        function.declaration.visitChildren(functionBodyAstVisitor);
        function.declaration.visitChildren(halsteadVolumeAstVisitor);

        _recorder.recordFunction(
            function,
            FunctionRecord(
                firstLine: parseResult.lineInfo
                    .getLocation(function
                        .declaration.firstTokenAfterCommentAndMetadata.offset)
                    .lineNumber,
                lastLine: parseResult.lineInfo
                    .getLocation(function.declaration.endToken.end)
                    .lineNumber,
                argumentsCount: getArgumentsCount(function),
                cyclomaticComplexityLines:
                    Map.unmodifiable(controlFlowAstVisitor.complexityLines),
                linesWithCode: functionBodyAstVisitor.linesWithCode,
                operators: Map.unmodifiable(halsteadVolumeAstVisitor.operators),
                operands: Map.unmodifiable(halsteadVolumeAstVisitor.operands)));
      }

      final ignores = IgnoreInfo.calculateIgnores(
          parseResult.content, parseResult.lineInfo);

      _recorder.recordIssues(_checkingCodeRules
          .where((rule) => !ignores.ignoreRule(rule.id))
          .expand((rule) => rule
              .check(parseResult.unit, Uri.parse(filePath), parseResult.content)
              .where((issue) => !ignores.ignoredAt(
                  issue.ruleId, issue.sourceSpan.start.line))));

      _recorder.endRecordFile();
    }
  }
}
