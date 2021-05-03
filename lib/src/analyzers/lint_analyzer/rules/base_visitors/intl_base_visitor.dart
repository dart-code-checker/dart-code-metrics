import 'package:analyzer/dart/ast/ast.dart';
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
  void addIssue(IntlBaseIssue? issue) {
    if (issue != null) {
      _issues.add(issue);
    }
  }

  @protected
  void addIssues(Iterable<IntlBaseIssue>? issues) {
    if (issues != null) {
      _issues.addAll(issues);
    }
  }

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    if (node.fields.type?.as<TypeName>()?.name.name != 'String') {
      return;
    }

    final className = node.parent?.as<NamedCompilationUnitMember>()?.name.name;

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

    final methodName = node.name.name;
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
    final methodName = node.name.name;
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
    String? className,
    String? variableName,
    FormalParameterList? parameterList,
  });

  void _checkVariables(String? className, VariableDeclarationList variables) {
    for (final variable in variables.variables) {
      final initializer = variable.initializer?.as<MethodInvocation>();
      if (initializer != null) {
        final variableName = variable.name.name;

        _checkMethodInvocation(
          initializer,
          className: className,
          variableName: variableName,
        );
      }
    }
  }

  String? _getClassName(MethodDeclaration node) {
    final name = node.parent?.as<NamedCompilationUnitMember>()?.name.name;

    return name ?? node.parent?.as<ExtensionDeclaration>()?.name?.name;
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
    String? className,
    String? variableName,
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

@immutable
abstract class IntlBaseIssue {
  final AstNode node;
  final String? nameFailure;

  const IntlBaseIssue(
    this.node, {
    this.nameFailure,
  });
}
