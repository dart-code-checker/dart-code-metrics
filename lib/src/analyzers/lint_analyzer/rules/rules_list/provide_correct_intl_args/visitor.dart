part of 'provide_correct_intl_args_rule.dart';

class _Visitor extends IntlBaseVisitor {
  @override
  void checkMethodInvocation(
    MethodInvocation methodInvocation, {
    String? className,
    String? variableName,
    FormalParameterList? parameterList,
  }) {
    switch (methodInvocation.methodName.name) {
      case 'message':
        _checkMessageMethod(
          methodInvocation,
          parameterList,
        );
        break;
    }
  }

  // ignore: long-method
  void _checkMessageMethod(
    MethodInvocation methodInvocation,
    FormalParameterList? parameterList,
  ) {
    final arguments = methodInvocation.argumentList.arguments;
    final argsArgument = arguments
        .whereType<NamedExpression>()
        .where((argument) => argument.name.label.name == 'args')
        .firstOrNull
        ?.expression
        .as<ListLiteral>();

    final parameterSimpleIdentifiers = parameterList?.parameters
            .map((parameter) => parameter.identifier)
            .toList() ??
        <SimpleIdentifier>[];

    if (argsArgument != null && parameterSimpleIdentifiers.isEmpty) {
      addIssue(_ArgsMustBeOmittedIssue(argsArgument));
    }

    if (argsArgument == null &&
        parameterList != null &&
        parameterSimpleIdentifiers.isNotEmpty) {
      addIssue(_NotExistArgsIssue(parameterList));
    }

    _checkAllArgsElementsMustBeSimpleIdentifier(argsArgument);

    final argsSimpleIdentifiers =
        argsArgument?.elements.whereType<SimpleIdentifier>().toList() ??
            <SimpleIdentifier>[];

    _checkAllParametersMustBeContainsInArgs(
      parameterSimpleIdentifiers,
      argsSimpleIdentifiers,
    );
    _checkAllArgsMustBeContainsInParameters(
      argsSimpleIdentifiers,
      parameterSimpleIdentifiers,
    );

    final messageArgument = arguments.first.as<StringInterpolation>();

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
          parameterSimpleIdentifiers,
        );
        _checkAllInterpolationMustBeContainsInArgs(
          interpolationExpressionSimpleIdentifiers,
          argsSimpleIdentifiers,
        );
      }
    } else {
      for (final item in parameterSimpleIdentifiers) {
        if (item != null) {
          addIssue(_ParameterMustBeOmittedIssue(item));
          addIssue(_ArgsItemMustBeOmittedIssue(item));
        }
      }
    }
  }

  void _checkAllArgsElementsMustBeSimpleIdentifier(
    ListLiteral? argsListLiteral,
  ) {
    final argsElements = argsListLiteral?.elements ?? <CollectionElement>[];

    _checkItemsOnSimple(argsElements);
  }

  void _checkItemsOnSimple<T extends AstNode>(Iterable<T> items) {
    addIssues(items
        .where((item) => item is! SimpleIdentifier)
        .map(_MustBeSimpleIdentifierIssue.new));
  }

  void _checkAllParametersMustBeContainsInArgs(
    Iterable<SimpleIdentifier?> parameters,
    Iterable<SimpleIdentifier> argsArgument,
  ) {
    _addIssuesIfNotContains(
      parameters,
      argsArgument,
      _ParameterMustBeInArgsIssue.new,
    );
  }

  void _checkAllArgsMustBeContainsInParameters(
    Iterable<SimpleIdentifier> argsArgument,
    Iterable<SimpleIdentifier?> parameters,
  ) {
    _addIssuesIfNotContains(
      argsArgument,
      parameters,
      _ArgsMustBeInParameterIssue.new,
    );
  }

  void _checkAllInterpolationMustBeContainsInParameters(
    Iterable<SimpleIdentifier> simpleIdentifierExpressions,
    Iterable<SimpleIdentifier?> parameters,
  ) {
    _addIssuesIfNotContains(
      simpleIdentifierExpressions,
      parameters,
      _InterpolationMustBeInParameterIssue.new,
    );
  }

  void _checkAllInterpolationMustBeContainsInArgs(
    Iterable<SimpleIdentifier> simpleIdentifierExpressions,
    Iterable<SimpleIdentifier> args,
  ) {
    _addIssuesIfNotContains(
      simpleIdentifierExpressions,
      args,
      _InterpolationMustBeInArgsIssue.new,
    );
  }

  void _addIssuesIfNotContains(
    Iterable<SimpleIdentifier?> checkedItems,
    Iterable<SimpleIdentifier?> existsItems,
    IntlBaseIssue Function(SimpleIdentifier args) issueFactory,
  ) {
    final argsNames = existsItems.map((item) => item?.token.lexeme).toSet();

    addIssues(checkedItems
        .where((arg) => !argsNames.contains(arg?.token.lexeme))
        .whereNotNull()
        .map(issueFactory));
  }
}

class _NotExistArgsIssue extends IntlBaseIssue {
  const _NotExistArgsIssue(
    super.node,
  ) : super(nameFailure: 'Parameter "args" should be added');
}

class _ArgsMustBeOmittedIssue extends IntlBaseIssue {
  const _ArgsMustBeOmittedIssue(
    super.node,
  ) : super(nameFailure: 'Parameter "args" should be removed');
}

class _ArgsItemMustBeOmittedIssue extends IntlBaseIssue {
  const _ArgsItemMustBeOmittedIssue(
    super.node,
  ) : super(nameFailure: 'Item is unused and should be removed');
}

class _ParameterMustBeOmittedIssue extends IntlBaseIssue {
  const _ParameterMustBeOmittedIssue(
    super.node,
  ) : super(nameFailure: 'Parameter is unused and should be removed');
}

class _MustBeSimpleIdentifierIssue extends IntlBaseIssue {
  const _MustBeSimpleIdentifierIssue(
    super.node,
  ) : super(nameFailure: 'Item should be simple identifier');
}

class _ParameterMustBeInArgsIssue extends IntlBaseIssue {
  const _ParameterMustBeInArgsIssue(
    super.node,
  ) : super(nameFailure: 'Parameter should be added to args');
}

class _ArgsMustBeInParameterIssue extends IntlBaseIssue {
  const _ArgsMustBeInParameterIssue(
    super.node,
  ) : super(nameFailure: 'Args item should be added to parameters');
}

class _InterpolationMustBeInArgsIssue extends IntlBaseIssue {
  const _InterpolationMustBeInArgsIssue(
    super.node,
  ) : super(
          nameFailure: 'Interpolation expression should be added to args',
        );
}

class _InterpolationMustBeInParameterIssue extends IntlBaseIssue {
  const _InterpolationMustBeInParameterIssue(
    super.node,
  ) : super(
          nameFailure: 'Interpolation expression should be added to parameters',
        );
}
