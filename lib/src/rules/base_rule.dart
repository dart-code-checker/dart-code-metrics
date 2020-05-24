import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:meta/meta.dart';

abstract class BaseRule {
  final String id;

  const BaseRule({@required this.id});

  Iterable<CodeIssue> check(CompilationUnit unit, Uri sourceUrl);
}
