import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/rule_utils.dart';
import 'package:dart_code_metrics/src/utils/object_extensions.dart';
import 'package:dart_code_metrics/src/utils/iterable_extensions.dart';

import 'base_rule.dart';

class PreferIntlNameRule extends BaseRule {
  static const _intlPackageUrl = 'package:intl/intl.dart';
  static const _failure = 'Incorrect Intl name, should be';
  static const _correctionComment = 'Rename';

  const PreferIntlNameRule()
      : super(
          id: 'prefer-intl-name',
          severity: CodeIssueSeverity.warning,
        );

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

    return visitor.issues.map((issue) {
      final correction =
          "'${_Issue.getNewValue(issue.className, issue.variableName)}'";

      return createIssue(
        this,
        '$_failure $correction',
        correction,
        _correctionComment,
        sourceUrl,
        sourceContent,
        unit.lineInfo,
        issue.node,
      );
    }).toList(growable: false);
  }
}

class _Visitor extends GeneralizingAstVisitor<void> {
  static final _methodNames = [
    'message',
    'plural',
    'gender',
    'select',
  ];
  final _issues = <_Issue>[];

  Iterable<_Issue> get issues => _issues;

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    if (node.fields.type.as<TypeName>()?.name?.name != 'String') {
      return;
    }

    for (final variable in node.fields.variables) {
      final initializer = variable.initializer.as<MethodInvocation>();
      if (initializer != null) {
        final className = node.parent.as<ClassDeclaration>().name.name;
        final variableName = variable.name.name;

        _checkMethodInvocation(
          initializer,
          className: className,
          variableName: variableName,
        );
      }
    }

    super.visitFieldDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final className = node.parent.as<ClassDeclaration>().name.name;
    final methodName = node.name.name;

    final methodInvocation = _getMethodInvocation(node.body);

    if (methodInvocation != null) {
      _checkMethodInvocation(
        methodInvocation,
        className: className,
        variableName: methodName,
      );
    }

    super.visitMethodDeclaration(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final methodName = node.name.name;
    final methodInvocation = _getMethodInvocation(node.functionExpression.body);

    if (methodInvocation != null) {
      _checkMethodInvocation(
        methodInvocation,
        variableName: methodName,
      );
    }

    super.visitFunctionDeclaration(node);
  }

  MethodInvocation _getMethodInvocation(FunctionBody body) {
    final methodInvocation =
        body?.as<ExpressionFunctionBody>()?.expression?.as<MethodInvocation>();

    return methodInvocation ??
        body
            ?.as<BlockFunctionBody>()
            ?.block
            ?.statements
            ?.whereType<ReturnStatement>()
            ?.lastOrDefault()
            ?.expression
            ?.as<MethodInvocation>();
  }

  void _checkMethodInvocation(MethodInvocation methodInvocation,
      {String className, String variableName}) {
    if ((methodInvocation?.target?.as<SimpleIdentifier>()?.name != 'Intl') ||
        !_methodNames.contains(methodInvocation?.methodName?.name)) {
      return;
    }

    final nameExpression = methodInvocation?.argumentList?.arguments
        ?.whereType<NamedExpression>()
        ?.where((argument) => argument.name.label.name == 'name')
        ?.firstOrDefault()
        ?.expression
        ?.as<SimpleStringLiteral>();

    if (nameExpression?.value != _Issue.getNewValue(className, variableName)) {
      _issues.add(_Issue(className, variableName, nameExpression));
    }
  }
}

class _Issue {
  final String className;
  final String variableName;
  final AstNode node;

  _Issue(
    this.className,
    this.variableName,
    this.node,
  );

  static String getNewValue(String className, String variableName) =>
      className != null ? '${className}_$variableName' : '$variableName';
}
