part of 'arguments_ordering_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final bool childLast;

  static const _childArg = 'child';
  static const _childrenArg = 'children';
  static const _childArgs = [_childArg, _childrenArg];

  final _issues = <_IssueDetails>[];

  Iterable<_IssueDetails> get issues => _issues;

  _Visitor({required this.childLast});

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    super.visitInstanceCreationExpression(node);

    _checkOrder(
      node.argumentList,
      node.constructorName.staticElement?.parameters ?? [],
    );
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);
    final staticElement = node.methodName.staticElement;
    if (staticElement is FunctionElement) {
      _checkOrder(
        node.argumentList,
        staticElement.parameters,
      );
    }
  }

  void _checkOrder(
    ArgumentList argumentList,
    List<ParameterElement> parameters,
  ) {
    final sortedArguments = argumentList.arguments.sorted((a, b) {
      if (a is! NamedExpression && b is! NamedExpression) {
        return 0;
      }
      if (a is NamedExpression && b is! NamedExpression) {
        return 1;
      }
      if (a is! NamedExpression && b is NamedExpression) {
        return -1;
      }
      if (a is NamedExpression && b is NamedExpression) {
        final aName = a.name.label.name;
        final bName = b.name.label.name;

        if (aName == bName) {
          return 0;
        }

        // We use simplified version for "child" argument check from "sort_child_properties_last" rule
        // https://github.com/dart-lang/linter/blob/1933b2a2969380e5db35d6aec524fb21b0ed028b/lib/src/rules/sort_child_properties_last.dart#L140
        // Hopefully, this will be enough for our current needs.
        if (childLast &&
            _childArgs.any((name) => name == aName || name == bName)) {
          return (_childArgs.contains(aName) && !_childArgs.contains(bName)) ||
                  (aName == _childArg)
              ? 1
              : -1;
        }

        return _parameterIndex(parameters, a)
            .compareTo(_parameterIndex(parameters, b));
      }

      return 0;
    });

    if (argumentList.arguments.toString() != sortedArguments.toString()) {
      _issues.add(
        _IssueDetails(
          argumentList: argumentList,
          replacement: '(${sortedArguments.join(', ')})',
        ),
      );
    }
  }

  static int _parameterIndex(
    List<ParameterElement> parameters,
    NamedExpression argumentExpression,
  ) =>
      parameters.indexWhere(
        (parameter) => parameter.name == argumentExpression.name.label.name,
      );
}

class _IssueDetails {
  const _IssueDetails({
    required this.argumentList,
    required this.replacement,
  });

  final ArgumentList argumentList;
  final String replacement;
}
