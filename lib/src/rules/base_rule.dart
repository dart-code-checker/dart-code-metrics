import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:meta/meta.dart';

abstract class BaseRule {
  final String id;
  final Uri documentation;
  final CodeIssueSeverity severity;

  const BaseRule({
    @required this.id,
    @required this.documentation,
    @required this.severity,
  });

  Iterable<CodeIssue> check(
      CompilationUnit unit, Uri sourceUrl, String sourceContent);
}
