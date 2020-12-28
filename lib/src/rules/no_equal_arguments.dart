import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:code_checker/analysis.dart';

import '../models/code_issue.dart';
import 'base_rule.dart';
import 'rule_utils.dart';

class NoEqualArguments extends BaseRule {
  static const String ruleId = 'no-equal-arguments';
  static const _documentationUrl = 'https://git.io/JUlBH';

  static const _warningMessage = 'The argument has already been passed';

  NoEqualArguments({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentation: Uri.parse(_documentationUrl),
          severity: Severity.fromJson(config['severity'] as String) ??
              Severity.warning,
        );

  @override
  Iterable<CodeIssue> check(ProcessedFile source) {
    final _visitor = _Visitor();

    source.parsedContent.visitChildren(_visitor);

    return _visitor.arguments
        .map((argument) => createIssue(
              this,
              _warningMessage,
              null,
              null,
              source.url,
              source.content,
              source.parsedContent.lineInfo,
              argument,
            ))
        .toList(growable: false);
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final _arguments = <Expression>[];

  Iterable<Expression> get arguments => _arguments;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    _visitArguments(node.argumentList.arguments);
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    super.visitFunctionExpressionInvocation(node);

    _visitArguments(node.argumentList.arguments);
  }

  void _visitArguments(NodeList<Expression> arguments) {
    for (final argument in arguments) {
      final lastAppearance = arguments.lastWhere((arg) {
        if (argument is NamedExpression &&
            arg is NamedExpression &&
            argument.expression is! Literal &&
            arg.expression is! Literal) {
          return argument.expression.toString() == arg.expression.toString();
        }

        if (_bothLiterals(argument, arg)) {
          return argument == arg;
        }

        return argument.toString() == arg.toString();
      });

      if (argument != lastAppearance) {
        _arguments.add(lastAppearance);
      }
    }
  }

  bool _bothLiterals(Expression left, Expression right) =>
      left is Literal && right is Literal ||
      (left is PrefixExpression &&
          left.operand is Literal &&
          right is PrefixExpression &&
          right.operand is Literal);
}
