import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:collection/collection.dart';

import '../../models/issue.dart';
import '../../models/severity.dart';
import '../../utils/node_utils.dart';
import '../../utils/rule_utils.dart';
import 'obsolete_rule.dart';

// Inspired by PVS-Studio (https://www.viva64.com/en/w/v6022/)

class AvoidUnusedParameters extends ObsoleteRule {
  static const String ruleId = 'avoid-unused-parameters';

  static const _warningMessage = 'Parameter is unused';
  static const _renameMessage =
      'Parameter is unused, consider renaming it to _, __, etc.';

  AvoidUnusedParameters({
    Map<String, Object> config = const {},
  }) : super(
          id: ruleId,
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(ResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit?.visitChildren(_visitor);

    return [
      ..._visitor.unusedParameters
          .map((parameter) => createIssue(
                rule: this,
                location: nodeLocation(
                  node: parameter,
                  source: source,
                  withCommentOrMetadata: true,
                ),
                message: _warningMessage,
              ))
          .toList(growable: false),
      ..._visitor.renameSuggestions
          .map((parameter) => createIssue(
                rule: this,
                location: nodeLocation(
                  node: parameter,
                  source: source,
                  withCommentOrMetadata: true,
                ),
                message: _renameMessage,
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
        (parameters == null || parameters.parameters.isEmpty)) {
      return;
    }

    final isOverride = node.metadata.firstWhereOrNull(
          (node) =>
              node.name.name == 'override' && node.atSign.type.lexeme == '@',
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
        (parameters == null || parameters.parameters.isEmpty)) {
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

    final names = parameters
        .map((parameter) => parameter.identifier?.name)
        .whereNotNull()
        .toList();
    final usedNames = _getUsedNames(children, names, []);

    for (final parameter in parameters) {
      final name = parameter.identifier?.name;
      if (name != null && !usedNames.contains(name)) {
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
        final parameters = child.parameters;
        if (parameters != null) {
          for (final parameter in parameters.parameters) {
            final name = parameter.identifier?.name;
            if (name != null) {
              ignoredForSubtree.add(name);
            }
          }
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
      parameter.identifier != null &&
      parameter.identifier!.name.replaceAll('_', '').isNotEmpty;
}
