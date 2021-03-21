// ignore_for_file: public_member_api_docs
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:code_checker/checker.dart';
import 'package:code_checker/rules.dart';

// Inspired by PVS-Studio (https://www.viva64.com/en/w/v6022/)

class AvoidUnusedParameters extends Rule {
  static const String ruleId = 'avoid-unused-parameters';
  static const _documentationUrl = 'https://git.io/JL153';

  static const _warningMessage = 'Parameter is unused';
  static const _renameMessage =
      'Parameter is unused, consider renaming it to _, __, etc.';

  AvoidUnusedParameters({
    Map<String, Object> config = const {},
  }) : super(
          id: ruleId,
          documentation: Uri.parse(_documentationUrl),
          severity: readSeverity(config, Severity.warning),
        );

  @override
  Iterable<Issue> check(ResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit.visitChildren(_visitor);

    return [
      ..._visitor.unusedParameters
          .map((parameter) => createIssue(
                this,
                nodeLocation(
                  node: parameter,
                  source: source,
                  withCommentOrMetadata: true,
                ),
                _warningMessage,
                null,
              ))
          .toList(growable: false),
      ..._visitor.renameSuggestions
          .map((parameter) => createIssue(
                this,
                nodeLocation(
                  node: parameter,
                  source: source,
                  withCommentOrMetadata: true,
                ),
                _renameMessage,
                null,
              ))
          .toList(),
    ];
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final _unusedParameters = <FormalParameter>[];
  final _renameSuggestions = <FormalParameter>[];

  Iterable<FormalParameter> get unusedParameters => _unusedParameters;

  Iterable<FormalParameter> get renameSuggestions => _renameSuggestions;

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    super.visitMethodDeclaration(node);

    final parent = node.parent;
    final parameters = node.parameters;

    if (parent is ClassDeclaration && parent.isAbstract ||
        node.externalKeyword != null ||
        (parameters?.parameters?.isEmpty ?? true)) {
      return;
    }

    final isOverride = node.metadata.firstWhere(
          (node) =>
              node.name.name == 'override' && node.atSign.type.lexeme == '@',
          orElse: () => null,
        ) !=
        null;

    if (isOverride) {
      _renameSuggestions.addAll(
        _getUnusedParameters(
          node.body.childEntities,
          parameters.parameters,
        ).where(_hasNoUnderscoresInName),
      );
    } else {
      _unusedParameters.addAll(
        _getUnusedParameters(
          node.body.childEntities,
          parameters.parameters,
        ).where(_hasNoUnderscoresInName),
      );
    }
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    super.visitFunctionDeclaration(node);

    final parameters = node.functionExpression.parameters;

    if (node.externalKeyword != null ||
        (parameters?.parameters?.isEmpty ?? true)) {
      return;
    }

    _unusedParameters.addAll(
      _getUnusedParameters(
        node.functionExpression.body.childEntities,
        parameters.parameters,
      ).where(_hasNoUnderscoresInName),
    );
  }

  Iterable<FormalParameter> _getUnusedParameters(
    Iterable<SyntacticEntity> children,
    NodeList<FormalParameter> parameters,
  ) {
    final result = <FormalParameter>[];

    final names =
        parameters.map((parameter) => parameter.identifier.name).toList();
    final usedNames = _getUsedNames(children, names, []);

    for (final parameter in parameters) {
      if (!usedNames.contains(parameter.identifier.name)) {
        result.add(parameter);
      }
    }

    return result;
  }

  Iterable<String> _getUsedNames(
    Iterable<SyntacticEntity> children,
    List<String> parametersNames,
    Iterable<String> ignoredNames,
  ) {
    final usedNames = <String>[];
    final ignoredForSubtree = [...ignoredNames];

    if (parametersNames.isEmpty) {
      return usedNames;
    }

    for (final child in children) {
      if (child is FunctionExpression) {
        for (final parameter in child.parameters.parameters) {
          ignoredForSubtree.add(parameter.identifier.name);
        }
      } else if (child is Identifier &&
          parametersNames.contains(child.name) &&
          !ignoredForSubtree.contains(child.name) &&
          !(child.parent is PropertyAccess &&
              (child.parent as PropertyAccess).target != child)) {
        final name = child.name;

        parametersNames.remove(name);
        usedNames.add(name);
      }

      if (child is AstNode) {
        usedNames.addAll(_getUsedNames(
          child.childEntities,
          parametersNames,
          ignoredForSubtree,
        ));
      }
    }

    return usedNames;
  }

  bool _hasNoUnderscoresInName(FormalParameter parameter) =>
      parameter.identifier.name.replaceAll('_', '').isNotEmpty;
}
