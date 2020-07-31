import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';

import 'base_rule.dart';
import 'rule_utils.dart';

class PreferOnPushCdStrategyRule extends BaseRule {
  static const String ruleId = 'prefer-on-push-cd-strategy';

  static const _failure = 'Prefer using onPush change detection strategy.';

  PreferOnPushCdStrategyRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          severity: CodeIssueSeverity.fromJson(config['severity'] as String) ??
              CodeIssueSeverity.warning,
        );

  @override
  Iterable<CodeIssue> check(
      CompilationUnit unit, Uri sourceUrl, String sourceContent) {
    final visitor = _Visitor();

    unit.visitChildren(visitor);

    return visitor.expression
        .map((expression) => createIssue(this, _failure, null, null, sourceUrl,
            sourceContent, unit.lineInfo, expression))
        .toList(growable: false);
  }
}

class _Visitor extends RecursiveAstVisitor<Object> {
  final _expression = <AstNode>[];

  Iterable<AstNode> get expression => _expression;

  @override
  void visitAnnotation(Annotation node) {
    if (!_isComponentAnnotation(node)) {
      return;
    }

    final changeDetectionArg = node.arguments.arguments
        .whereType<NamedExpression>()
        .firstWhere((arg) => arg.name.label.name == 'changeDetection',
            orElse: () => null);

    if (changeDetectionArg == null) {
      return _expression.add(node);
    }

    final value = changeDetectionArg.expression;
    if (value is PrefixedIdentifier && _isCorrectStrategy(value)) {
      return _expression.add(changeDetectionArg);
    }

    return _expression.add(changeDetectionArg);
  }

  bool _isCorrectStrategy(PrefixedIdentifier identifier) =>
      identifier.prefix.name == 'ChangeDetectionStrategy' &&
      identifier.identifier.name == 'OnPush';

  bool _isComponentAnnotation(Annotation node) =>
      node.name.name == 'Component' &&
      node.atSign.type.lexeme == '@' &&
      node.parent is ClassDeclaration;
}
