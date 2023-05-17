// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../../../../utils/object_extensions.dart';

abstract class IntlBaseVisitor extends GeneralizingAstVisitor<void> {
  static final _methodNames = [
    'message',
    'plural',
    'gender',
    'select',
  ];

  final _issues = <IntlBaseIssue>[];

  Iterable<IntlBaseIssue> get issues => _issues;

  @protected
  void addIssue(IntlBaseIssue issue) {
    _issues.add(issue);
  }

  @protected
  void addIssues(Iterable<IntlBaseIssue> issues) {
    _issues.addAll(issues);
  }

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    // ignore: deprecated_member_use
    if (node.fields.type?.as<NamedType>()?.name.name != 'String') {
      return;
    }

    final className =
        node.parent?.as<NamedCompilationUnitMember>()?.name.lexeme;

    _checkVariables(className, node.fields);

    super.visitFieldDeclaration(node);
  }

  @override
  void visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    _checkVariables(null, node.variables);

    super.visitTopLevelVariableDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final className = _getClassName(node);

    if (className == null) {
      return;
    }

    final methodName = node.name.lexeme;
    final methodParameters = node.parameters;

    final methodInvocation = _getMethodInvocation(node.body);

    if (methodInvocation != null) {
      _checkMethodInvocation(
        methodInvocation,
        className: className,
        variableName: methodName,
        parameterList: methodParameters,
      );
    }

    super.visitMethodDeclaration(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final methodName = node.name.lexeme;
    final methodParameters = node.functionExpression.parameters;
    final methodInvocation = _getMethodInvocation(node.functionExpression.body);

    if (methodInvocation != null) {
      _checkMethodInvocation(
        methodInvocation,
        variableName: methodName,
        parameterList: methodParameters,
      );
    }

    super.visitFunctionDeclaration(node);
  }

  @protected
  void checkMethodInvocation(
    MethodInvocation methodInvocation, {
    required String variableName,
    String? className,
    FormalParameterList? parameterList,
  });

  void _checkVariables(String? className, VariableDeclarationList variables) {
    for (final variable in variables.variables) {
      final initializer = variable.initializer?.as<MethodInvocation>();
      if (initializer != null) {
        final variableName = variable.name.lexeme;

        _checkMethodInvocation(
          initializer,
          className: className,
          variableName: variableName,
        );
      }
    }
  }

  String? _getClassName(MethodDeclaration node) {
    final name = node.parent?.as<NamedCompilationUnitMember>()?.name.lexeme;

    return name ?? node.parent?.as<ExtensionDeclaration>()?.name?.lexeme;
  }

  MethodInvocation? _getMethodInvocation(FunctionBody body) {
    final methodInvocation =
        body.as<ExpressionFunctionBody>()?.expression.as<MethodInvocation>();

    return methodInvocation ??
        body
            .as<BlockFunctionBody>()
            ?.block
            .statements
            .whereType<ReturnStatement>()
            .lastOrNull
            ?.expression
            ?.as<MethodInvocation>();
  }

  void _checkMethodInvocation(
    MethodInvocation methodInvocation, {
    required String variableName,
    String? className,
    FormalParameterList? parameterList,
  }) {
    if ((methodInvocation.target?.as<SimpleIdentifier>()?.name != 'Intl') ||
        !_methodNames.contains(methodInvocation.methodName.name)) {
      return;
    }

    checkMethodInvocation(
      methodInvocation,
      className: className,
      variableName: variableName,
      parameterList: parameterList,
    );
  }
}

abstract class IntlBaseIssue {
  final SyntacticEntity node;
  final String? nameFailure;

  const IntlBaseIssue(
    this.node, {
    this.nameFailure,
  });
}
