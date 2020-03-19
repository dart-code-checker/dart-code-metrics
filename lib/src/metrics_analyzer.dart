import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dart_code_metrics/src/cyclomatic_complexity/control_flow_ast_visitor.dart';
import 'package:dart_code_metrics/src/cyclomatic_complexity/cyclomatic_config.dart';
import 'package:dart_code_metrics/src/halstead_volume/halstead_volume_ast_visitor.dart';
import 'package:dart_code_metrics/src/lines_of_code/function_body_ast_visitor.dart';
import 'package:dart_code_metrics/src/metrics_analysis_recorder.dart';
import 'package:dart_code_metrics/src/metrics_analyzer_utils.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/scope_ast_visitor.dart';
import 'package:path/path.dart' as p;

/// Performs code quality analysis on specified files
/// See [MetricsAnalysisRunner] to get analysis info
class MetricsAnalyzer {
  final MetricsAnalysisRecorder _recorder;

  MetricsAnalyzer(this._recorder);

  void runAnalysis(String filePath, String rootFolder) {
    final visitor = ScopeAstVisitor();
    final parseResult = parseFile(
        path: p.normalize(p.absolute(filePath)),
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false);
    parseResult.unit.visitChildren(visitor);

    if (visitor.declarations.isNotEmpty) {
      _recorder.startRecordFile(filePath, rootFolder);

      for (final scopedDeclaration in visitor.declarations) {
        final controlFlowAstVisitor = ControlFlowAstVisitor(
            defaultCyclomaticConfig, parseResult.lineInfo);
        final functionBodyAstVisitor =
            FunctionBodyAstVisitor(parseResult.lineInfo);
        final halsteadVolumeAstVisitor = HalsteadVolumeAstVisitor();

        scopedDeclaration.declaration.visitChildren(controlFlowAstVisitor);
        scopedDeclaration.declaration.visitChildren(functionBodyAstVisitor);
        scopedDeclaration.declaration.visitChildren(halsteadVolumeAstVisitor);

        _recorder.record(
            getQualifiedName(scopedDeclaration),
            FunctionRecord(
                firstLine: parseResult.lineInfo
                    .getLocation(scopedDeclaration
                        .declaration.firstTokenAfterCommentAndMetadata.offset)
                    .lineNumber,
                lastLine: parseResult.lineInfo
                    .getLocation(scopedDeclaration.declaration.endToken.end)
                    .lineNumber,
                argumentsCount: getArgumentsCount(scopedDeclaration),
                cyclomaticLinesComplexity:
                    BuiltMap.from(controlFlowAstVisitor.complexityLines),
                linesWithCode: functionBodyAstVisitor.linesWithCode,
                operators: BuiltMap.from(halsteadVolumeAstVisitor.operators),
                operands: BuiltMap.from(halsteadVolumeAstVisitor.operands)));
      }

      _recorder.endRecordFile();
    }
  }
}
