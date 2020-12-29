import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:meta/meta.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';

@immutable
class FileRecord {
  final String fullPath;
  final String relativePath;

  final Map<String, ComponentRecord> components;
  final Map<String, FunctionRecord> functions;

  final Iterable<Issue> issues;
  final Iterable<Issue> designIssues;

  const FileRecord({
    @required this.fullPath,
    @required this.relativePath,
    @required this.components,
    @required this.functions,
    @required this.issues,
    @required this.designIssues,
  });
}
