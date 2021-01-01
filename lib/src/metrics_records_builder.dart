import 'package:code_checker/checker.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/models/scoped_function_declaration.dart';

/// [FileRecord] builder
abstract class MetricsRecordsBuilder {
  void recordComponent(
      ScopedClassDeclaration declaration, ComponentRecord record);

  void recordFunction(
      ScopedFunctionDeclaration declaration, FunctionRecord record);

  void recordDesignIssues(Iterable<Issue> issues);

  void recordIssues(Iterable<Issue> issues);
}
