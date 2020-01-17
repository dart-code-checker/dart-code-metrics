import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:built_collection/built_collection.dart';
import 'package:metrics/src/cyclomatic_complexity/control_flow_ast_visitor.dart';
import 'package:metrics/src/cyclomatic_complexity/cyclomatic_config.dart';
import 'package:metrics/src/cyclomatic_complexity/models/scoped_declaration.dart';
import 'package:metrics/src/halstead_volume/halstead_volume_ast_visitor.dart';
import 'package:metrics/src/lines_of_code/function_body_ast_visitor.dart';
import 'package:metrics/src/metrics_analysis_recorder.dart';
import 'package:metrics/src/models/function_record.dart';
import 'package:metrics/src/scope_ast_visitor.dart';

String getQualifiedName(ScopedDeclaration dec) {
  final declaration = dec.declaration;

  if (declaration is FunctionDeclaration) {
    return declaration.name.toString();
  } else if (declaration is MethodDeclaration) {
    return '${dec.enclosingClass.name}.${declaration.name}';
  }

  return null;
}

class MetricsAnalyzer {
  final MetricsAnalysisRecorder _recorder;

  MetricsAnalyzer(this._recorder);

  void runAnalysis(String filePath, String rootFolder) {
    final visitor = ScopeAstVisitor();
    final compilationUnit = parseDartFile(filePath, suppressErrors: true)..visitChildren(visitor);
    if (visitor.declarations.isNotEmpty) {
      _recorder.startRecordFile(filePath, rootFolder);

      for (final scopedDeclaration in visitor.declarations) {
        final controlFlowAstVisitor = ControlFlowAstVisitor(defaultCyclomaticConfig, compilationUnit.lineInfo);
        final functionBodyAstVisitor = FunctionBodyAstVisitor(compilationUnit.lineInfo);
        final halsteadVolumeAstVisitor = HalsteadVolumeAstVisitor();

        scopedDeclaration.declaration.visitChildren(controlFlowAstVisitor);
        scopedDeclaration.declaration.visitChildren(functionBodyAstVisitor);
        scopedDeclaration.declaration.visitChildren(halsteadVolumeAstVisitor);

        _recorder.record(
            getQualifiedName(scopedDeclaration),
            FunctionRecord(
                firstLine: compilationUnit.lineInfo
                    .getLocation(scopedDeclaration.declaration.firstTokenAfterCommentAndMetadata.offset)
                    .lineNumber,
                lastLine: compilationUnit.lineInfo.getLocation(scopedDeclaration.declaration.endToken.end).lineNumber,
                cyclomaticLinesComplexity: BuiltMap.from(controlFlowAstVisitor.complexityLines),
                linesWithCode: functionBodyAstVisitor.linesWithCode,
                operators: BuiltMap.from(halsteadVolumeAstVisitor.operators),
                operands: BuiltMap.from(halsteadVolumeAstVisitor.operands)));
      }

      _recorder.endRecordFile();
    }
  }
}
