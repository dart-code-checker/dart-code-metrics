import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../models/code_issue.dart';
import '../models/code_issue_severity.dart';
import '../models/source.dart';
import 'base_rule.dart';
import 'rule_utils.dart';

class AvoidPreserveWhitespaceFalseRule extends BaseRule {
  static const String ruleId = 'avoid-preserve-whitespace-false';
  static const _documentationUrl = 'https://git.io/JfDik';

  static const _failure = 'Avoid using preserveWhitespace: false.';

  AvoidPreserveWhitespaceFalseRule({Map<String, Object> config = const {}})
      : super(
            id: ruleId,
            documentation: Uri.parse(_documentationUrl),
            severity:
                CodeIssueSeverity.fromJson(config['severity'] as String) ??
                    CodeIssueSeverity.warning);

  @override
  Iterable<CodeIssue> check(Source source) {
    final visitor = _Visitor();

    source.compilationUnit.visitChildren(visitor);

    return visitor.expression
        .map((expression) => createIssue(this, _failure, null, null, source.url,
            source.content, source.compilationUnit.lineInfo, expression))
        .toList(growable: false);
  }
}

class _Visitor extends RecursiveAstVisitor<Object> {
  final _expression = <NamedExpression>[];

  Iterable<NamedExpression> get expression => _expression;

  @override
  void visitAnnotation(Annotation node) {
    if (node.name.name == 'Component' &&
        node.atSign.type.lexeme == '@' &&
        node.parent is ClassDeclaration) {
      final preserveWhitespaceArg = node.arguments.arguments
          .whereType<NamedExpression>()
          .firstWhere((arg) => arg.name.label.name == 'preserveWhitespace',
              orElse: () => null);
      if (preserveWhitespaceArg != null) {
        final expression = preserveWhitespaceArg.expression;
        if (expression is BooleanLiteral &&
            expression.literal.keyword == Keyword.FALSE) {
          _expression.add(preserveWhitespaceArg);
        }
      }
    }
  }
}
