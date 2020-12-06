import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import '../models/code_issue.dart';
import '../models/code_issue_severity.dart';
import '../models/source.dart';

import 'base_rule.dart';
import 'rule_utils.dart';

class PreferOnPushCdStrategyRule extends BaseRule {
  static const String ruleId = 'prefer-on-push-cd-strategy';
  static const _documentationUrl = 'https://git.io/JJwmB';

  static const _failure = 'Prefer using onPush change detection strategy.';

  PreferOnPushCdStrategyRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentation: Uri.parse(_documentationUrl),
          severity: CodeIssueSeverity.fromJson(config['severity'] as String) ??
              CodeIssueSeverity.warning,
        );

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

class _Visitor extends RecursiveAstVisitor<void> {
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
      return;
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
