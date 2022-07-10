part of 'prefer_extracting_callbacks_rule.dart';

class _Visitor extends SimpleAstVisitor<void> {
  final _expressions = <Expression>[];

  final LineInfo _lineInfo;
  final Iterable<String> _ignoredArguments;
  final int? _allowedLineCount;

  Iterable<Expression> get expressions => _expressions;

  _Visitor(this._lineInfo, this._ignoredArguments, this._allowedLineCount);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final classType = node.extendsClause?.superclass.type;
    if (!isWidgetOrSubclass(classType) && !isWidgetStateOrSubclass(classType)) {
      return;
    }

    final visitor = _InstanceCreationVisitor(
      _lineInfo,
      _ignoredArguments,
      _allowedLineCount,
    );
    node.visitChildren(visitor);

    _expressions.addAll(visitor.expressions);
  }
}

class _InstanceCreationVisitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  final LineInfo _lineInfo;
  final Iterable<String> _ignoredArguments;
  final int? _allowedLineCount;

  Iterable<Expression> get expressions => _expressions;

  _InstanceCreationVisitor(
    this._lineInfo,
    this._ignoredArguments,
    this._allowedLineCount,
  );

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    super.visitInstanceCreationExpression(node);

    for (final argument in node.argumentList.arguments) {
      final expression =
          argument is NamedExpression ? argument.expression : argument;

      if (_isNotIgnored(argument) &&
          expression is FunctionExpression &&
          _hasNotEmptyBlockBody(expression) &&
          !_isFlutterBuilder(expression) &&
          _isLongEnough(expression)) {
        _expressions.add(argument);
      }
    }
  }

  bool _hasNotEmptyBlockBody(FunctionExpression expression) {
    final body = expression.body;
    if (body is! BlockFunctionBody) {
      return false;
    }

    return body.block.statements.isNotEmpty;
  }

  bool _isFlutterBuilder(FunctionExpression expression) {
    if (!isWidgetOrSubclass(expression.declaredElement?.returnType)) {
      return false;
    }

    final formalParameters = expression.parameters?.parameters;

    return formalParameters == null ||
        formalParameters.isNotEmpty &&
            isBuildContext(formalParameters.first.declaredElement?.type);
  }

  bool _isNotIgnored(Expression argument) =>
      argument is! NamedExpression ||
      !_ignoredArguments.contains(argument.name.label.name);

  bool _isLongEnough(Expression expression) {
    final allowedLineCount = _allowedLineCount;
    if (allowedLineCount == null) {
      return true;
    }

    final visitor = SourceCodeVisitor(_lineInfo);
    expression.visitChildren(visitor);

    return visitor.linesWithCode.length > allowedLineCount;
  }
}
