import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/rule_utils.dart';
import 'package:dart_code_metrics/src/utils/object_extensions.dart';
import 'package:dart_code_metrics/src/utils/iterable_extensions.dart';
import 'package:meta/meta.dart';

import 'base_rule.dart';
import 'intl_base/intl_base_visitor.dart';

class ProvideCorrectIntlArgsRule extends BaseRule {
  static const String ruleId = 'provide-correct-intl-args';
  static const _documentationUrl = 'https://git.io/JJySX';

  static const _intlPackageUrl = 'package:intl/intl.dart';

  ProvideCorrectIntlArgsRule({Map<String, Object> config = const {}})
      : super(
            id: ruleId,
            documentation: Uri.parse(_documentationUrl),
            severity:
                CodeIssueSeverity.fromJson(config['severity'] as String) ??
                    CodeIssueSeverity.warning);

  @override
  Iterable<CodeIssue> check(
      CompilationUnit unit, Uri sourceUrl, String sourceContent) {
    final hasIntlDirective = unit.directives
        .whereType<ImportDirective>()
        .any((directive) => directive.uri.stringValue == _intlPackageUrl);

    if (!hasIntlDirective) {
      return [];
    }

    final visitor = _Visitor();
    unit.visitChildren(visitor);

    return visitor.issues
        .map((issue) => createIssue(
              this,
              issue.nameFailure,
              null,
              null,
              sourceUrl,
              sourceContent,
              unit.lineInfo,
              issue.node,
            ))
        .toList();
  }
}

class _Visitor extends IntlBaseVisitor {
  @override
  void checkMethodInvocation(MethodInvocation methodInvocation,
      {String className,
      String variableName,
      FormalParameterList parameterList}) {
    switch (methodInvocation.methodName.name) {
      case 'message':
        _checkMessageMethod(
          methodInvocation,
          parameterList,
        );
        break;
    }
  }

  void _checkMessageMethod(
      MethodInvocation methodInvocation, FormalParameterList parameterList) {
    final argsArgument = methodInvocation.argumentList?.arguments
        ?.whereType<NamedExpression>()
        ?.where((argument) => argument.name.label.name == 'args')
        ?.firstOrDefault()
        ?.expression
        ?.as<ListLiteral>();

    final parameterSimpleIdentifiers = parameterList?.parameters
            ?.map((parameter) => parameter.identifier)
            ?.toList() ??
        <SimpleIdentifier>[];

    if (argsArgument != null && parameterSimpleIdentifiers.isEmpty) {
      addIssue(_ArgsMustBeOmittedIssue(argsArgument));
    }

    if (argsArgument == null && parameterSimpleIdentifiers.isNotEmpty) {
      addIssue(_NotExistArgsIssue(parameterList));
    }

    _checkAllArgsElementsMustBeSimpleIdentifier(argsArgument);

    final argsSimpleIdentifiers =
        argsArgument?.elements?.whereType<SimpleIdentifier>()?.toList() ??
            <SimpleIdentifier>[];

    _checkAllParametersMustBeContainsInArgs(
        parameterSimpleIdentifiers, argsSimpleIdentifiers);
    _checkAllArgsMustBeContainsInParameters(
        argsSimpleIdentifiers, parameterSimpleIdentifiers);

    final messageArgument = methodInvocation.argumentList?.arguments
        ?.firstOrDefault()
        ?.as<StringInterpolation>();

    if (messageArgument != null) {
      final interpolationExpressions = messageArgument.elements
          .whereType<InterpolationExpression>()
          .map((expression) => expression.expression)
          .toList();

      _checkItemsOnSimple(interpolationExpressions);

      final interpolationExpressionSimpleIdentifiers =
          interpolationExpressions.whereType<SimpleIdentifier>().toList();

      if (argsArgument != null &&
          parameterSimpleIdentifiers.isEmpty &&
          interpolationExpressionSimpleIdentifiers.isEmpty) {
        addIssue(_ArgsMustBeOmittedIssue(argsArgument));
      }

      if (interpolationExpressionSimpleIdentifiers.isNotEmpty) {
        _checkAllInterpolationMustBeContainsInParameters(
            interpolationExpressionSimpleIdentifiers,
            parameterSimpleIdentifiers);
        _checkAllInterpolationMustBeContainsInArgs(
            interpolationExpressionSimpleIdentifiers, argsSimpleIdentifiers);
      }
    } else {
      for (final item in parameterSimpleIdentifiers) {
        addIssue(_ParameterMustBeOmittedIssue(item));
        addIssue(_ArgsItemMustBeOmittedIssue(item));
      }
    }
  }

  void _checkAllArgsElementsMustBeSimpleIdentifier(
      ListLiteral argsListLiteral) {
    final argsElements = argsListLiteral?.elements ?? <CollectionElement>[];

    _checkItemsOnSimple(argsElements);
  }

  void _checkItemsOnSimple<T extends AstNode>(Iterable<T> items) {
    addIssues(items
        ?.where((item) => item is! SimpleIdentifier)
        ?.map((item) => _MustBeSimpleIdentifierIssue(item)));
  }

  void _checkAllParametersMustBeContainsInArgs(
      List<SimpleIdentifier> parameters, List<SimpleIdentifier> argsArgument) {
    _addIssuesIfNotContains(
        parameters, argsArgument, (arg) => _ParameterMustBeInArgsIssue(arg));
  }

  void _checkAllArgsMustBeContainsInParameters(
      List<SimpleIdentifier> argsArgument, List<SimpleIdentifier> parameters) {
    _addIssuesIfNotContains(
        argsArgument, parameters, (arg) => _ArgsMustBeInParameterIssue(arg));
  }

  void _checkAllInterpolationMustBeContainsInParameters(
      List<SimpleIdentifier> simpleIdentifierExpressions,
      List<SimpleIdentifier> parameters) {
    _addIssuesIfNotContains(simpleIdentifierExpressions, parameters,
        (arg) => _InterpolationMustBeInParameterIssue(arg));
  }

  void _checkAllInterpolationMustBeContainsInArgs(
      List<SimpleIdentifier> simpleIdentifierExpressions,
      List<SimpleIdentifier> args) {
    _addIssuesIfNotContains(simpleIdentifierExpressions, args,
        (arg) => _InterpolationMustBeInArgsIssue(arg));
  }

  void _addIssuesIfNotContains(
    List<SimpleIdentifier> checkedItems,
    List<SimpleIdentifier> existsItems,
    IntlBaseIssue Function(SimpleIdentifier args) issueFactory,
  ) {
    final argsNames = existsItems.map((item) => item.token.value()).toSet();

    addIssues(checkedItems
        ?.where((arg) => !argsNames.contains(arg.token.value()))
        ?.map(issueFactory));
  }
}

@immutable
class _NotExistArgsIssue extends IntlBaseIssue {
  const _NotExistArgsIssue(
    AstNode node,
  ) : super(node, nameFailure: 'Parameter "args" should be added');
}

@immutable
class _ArgsMustBeOmittedIssue extends IntlBaseIssue {
  const _ArgsMustBeOmittedIssue(
    AstNode node,
  ) : super(node, nameFailure: 'Parameter "args" should be removed');
}

@immutable
class _ArgsItemMustBeOmittedIssue extends IntlBaseIssue {
  const _ArgsItemMustBeOmittedIssue(
    AstNode node,
  ) : super(node, nameFailure: 'Item is unused and should be removed');
}

@immutable
class _ParameterMustBeOmittedIssue extends IntlBaseIssue {
  const _ParameterMustBeOmittedIssue(
    AstNode node,
  ) : super(node, nameFailure: 'Parameter is unused and should be removed');
}

@immutable
class _MustBeSimpleIdentifierIssue extends IntlBaseIssue {
  const _MustBeSimpleIdentifierIssue(
    AstNode node,
  ) : super(node, nameFailure: 'Item should be simple identifier');
}

@immutable
class _ParameterMustBeInArgsIssue extends IntlBaseIssue {
  const _ParameterMustBeInArgsIssue(
    AstNode node,
  ) : super(node, nameFailure: 'Parameter should be added to args');
}

@immutable
class _ArgsMustBeInParameterIssue extends IntlBaseIssue {
  const _ArgsMustBeInParameterIssue(
    AstNode node,
  ) : super(node, nameFailure: 'Args item should be added to parameters');
}

@immutable
class _InterpolationMustBeInArgsIssue extends IntlBaseIssue {
  const _InterpolationMustBeInArgsIssue(
    AstNode node,
  ) : super(node,
            nameFailure: 'Interpolation expression should be added to args');
}

@immutable
class _InterpolationMustBeInParameterIssue extends IntlBaseIssue {
  const _InterpolationMustBeInParameterIssue(
    AstNode node,
  ) : super(node,
            nameFailure:
                'Interpolation expression should be added to parameters');
}
