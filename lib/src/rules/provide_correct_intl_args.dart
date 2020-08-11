import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/rule_utils.dart';
import 'package:dart_code_metrics/src/utils/object_extensions.dart';
import 'package:dart_code_metrics/src/utils/iterable_extensions.dart';
import 'package:meta/meta.dart';

import 'base_rule.dart';
import 'prefer_ints/intl_base_visitor.dart';

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

      addIssues(interpolationExpressions
          .where((item) => item is! SimpleIdentifier)
          .map((item) => _MustBeSimpleIdentifierIssue(item)));

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

    addIssues(argsElements
        ?.where((item) => item is! SimpleIdentifier)
        ?.map((item) => _MustBeSimpleIdentifierIssue(item)));
  }

  void _checkAllParametersMustBeContainsInArgs(
      List<SimpleIdentifier> parameters, List<SimpleIdentifier> argsArgument) {
    final argsNames = argsArgument.map((item) => item.token.value()).toSet();
    addIssues(parameters
        ?.where((param) => !argsNames.contains(param.token.value()))
        ?.map((param) => _ParameterMustBeInArgsIssue(param)));
  }

  void _checkAllArgsMustBeContainsInParameters(
      List<SimpleIdentifier> argsArgument, List<SimpleIdentifier> parameters) {
    final parametersNames =
        parameters.map((item) => item.token.value()).toSet();
    addIssues(argsArgument
        ?.where((arg) => !parametersNames.contains(arg.token.value()))
        ?.map((arg) => _ArgsMustBeInParameterIssue(arg)));
  }

  void _checkAllInterpolationMustBeContainsInParameters(
      List<SimpleIdentifier> simpleIdentifierExpressions,
      List<SimpleIdentifier> parameters) {
    final parametersNames =
        parameters.map((item) => item.token.value()).toSet();
    addIssues(simpleIdentifierExpressions
        ?.where((param) => !parametersNames.contains(param.token.value()))
        ?.map((param) => _InterpolationMustBeInParameterIssue(param)));
  }

  void _checkAllInterpolationMustBeContainsInArgs(
      List<SimpleIdentifier> simpleIdentifierExpressions,
      List<SimpleIdentifier> args) {
    final argsNames = args.map((item) => item.token.value()).toSet();

    addIssues(simpleIdentifierExpressions
        ?.where((arg) => !argsNames.contains(arg.token.value()))
        ?.map<_InterpolationMustBeInArgsIssue>(
            (arg) => _InterpolationMustBeInArgsIssue(arg)));
  }
}

@immutable
class _NotExistArgsIssue extends IntlBaseIssue {
  const _NotExistArgsIssue(
    AstNode node,
  ) : super(node, nameFailure: 'Parameter args should be exist');
}

@immutable
class _ArgsMustBeOmittedIssue extends IntlBaseIssue {
  const _ArgsMustBeOmittedIssue(
    AstNode node,
  ) : super(node, nameFailure: 'Parameter args should not be exist');
}

@immutable
class _ArgsItemMustBeOmittedIssue extends IntlBaseIssue {
  const _ArgsItemMustBeOmittedIssue(
    AstNode node,
  ) : super(node, nameFailure: 'Item should not be exist, because is not used');
}

@immutable
class _ParameterMustBeOmittedIssue extends IntlBaseIssue {
  const _ParameterMustBeOmittedIssue(
    AstNode node,
  ) : super(node,
            nameFailure: 'Parameter should not be exist, because is not used');
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
  ) : super(node, nameFailure: 'Parameter item should be contains in args');
}

@immutable
class _ArgsMustBeInParameterIssue extends IntlBaseIssue {
  const _ArgsMustBeInParameterIssue(
    AstNode node,
  ) : super(node, nameFailure: 'Args item should be contains in parameters');
}

@immutable
class _InterpolationMustBeInArgsIssue extends IntlBaseIssue {
  const _InterpolationMustBeInArgsIssue(
    AstNode node,
  ) : super(node, nameFailure: 'Interpolation must be contains in args');
}

@immutable
class _InterpolationMustBeInParameterIssue extends IntlBaseIssue {
  const _InterpolationMustBeInParameterIssue(
    AstNode node,
  ) : super(node, nameFailure: 'Interpolation must be contains in parameters');
}
