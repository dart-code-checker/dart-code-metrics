// ignore_for_file: public_member_api_docs
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:code_checker/checker.dart';
import 'package:code_checker/rules.dart';

class AvoidPreserveWhitespaceFalseRule extends Rule {
  static const String ruleId = 'avoid-preserve-whitespace-false';
  static const _documentationUrl = 'https://git.io/JfDik';

  static const _failure = 'Avoid using preserveWhitespace: false.';

  AvoidPreserveWhitespaceFalseRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentation: Uri.parse(_documentationUrl),
          severity: readSeverity(config, Severity.warning),
        );

  @override
  Iterable<Issue> check(ResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    return visitor.expression
        .map((expression) => createIssue(
              this,
              nodeLocation(
                node: expression,
                source: source,
                withCommentOrMetadata: true,
              ),
              _failure,
              null,
            ))
        .toList(growable: false);
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final _expression = <NamedExpression>[];

  Iterable<NamedExpression> get expression => _expression;

  @override
  void visitAnnotation(Annotation node) {
    if (node.name.name == 'Component' &&
        node.atSign.type.lexeme == '@' &&
        node.parent is ClassDeclaration) {
      final preserveWhitespaceArg =
          node.arguments.arguments.whereType<NamedExpression>().firstWhere(
                (arg) => arg.name.label.name == 'preserveWhitespace',
                orElse: () => null,
              );
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
