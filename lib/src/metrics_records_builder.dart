import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/models/scoped_component_declaration.dart';
import 'package:dart_code_metrics/src/models/scoped_function_declaration.dart';

abstract class MetricsRecordsBuilder {
  void recordComponent(
      ScopedComponentDeclaration declaration, ComponentRecord record);
  void recordFunction(
      ScopedFunctionDeclaration declaration, FunctionRecord record);
  void recordIssues(Iterable<CodeIssue> issues);
}
