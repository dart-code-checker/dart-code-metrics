import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../models/obsolete_rule.dart';
import '../rule_utils.dart';

class NoEqualArguments extends ObsoleteRule {
  static const String ruleId = 'no-equal-arguments';

  static const _warningMessage = 'The argument has already been passed';

  NoEqualArguments({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit.visitChildren(_visitor);

    return _visitor.arguments
        .map((argument) => createIssue(
              rule: this,
              location: nodeLocation(
                node: argument,
                source: source,
                withCommentOrMetadata: true,
              ),
              message: _warningMessage,
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

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    super.visitInstanceCreationExpression(node);

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
