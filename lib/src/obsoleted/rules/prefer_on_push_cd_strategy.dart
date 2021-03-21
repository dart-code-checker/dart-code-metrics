// ignore_for_file: public_member_api_docs
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:code_checker/checker.dart';
import 'package:code_checker/rules.dart';

class PreferOnPushCdStrategyRule extends Rule {
  static const String ruleId = 'prefer-on-push-cd-strategy';
  static const _documentationUrl = 'https://git.io/JJwmB';

  static const _failure = 'Prefer using onPush change detection strategy.';

  PreferOnPushCdStrategyRule({Map<String, Object> config = const {}})
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
  final _expression = <AstNode>[];

  Iterable<AstNode> get expression => _expression;

  @override
  void visitAnnotation(Annotation node) {
    if (!_isComponentAnnotation(node)) {
      return;
    }

    final changeDetectionArg =
        node.arguments.arguments.whereType<NamedExpression>().firstWhere(
              (arg) => arg.name.label.name == 'changeDetection',
              orElse: () => null,
            );

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
