import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:meta/meta.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';

@immutable
class ComponentRecord {
  final String fullPath;
  final String relativePath;

  final Map<String, FunctionRecord> functions;

  final Iterable<CodeIssue> issues;

  const ComponentRecord({
    @required this.fullPath,
    @required this.relativePath,
    @required this.functions,
    @required this.issues,
  });
}
