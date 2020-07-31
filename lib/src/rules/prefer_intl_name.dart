import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/rule_utils.dart';
import 'package:dart_code_metrics/src/utils/object_extensions.dart';
import 'package:dart_code_metrics/src/utils/iterable_extensions.dart';
import 'package:meta/meta.dart';

import 'base_rule.dart';

class PreferIntlNameRule extends BaseRule {
  static const String ruleId = 'prefer-intl-name';

  static const _intlPackageUrl = 'package:intl/intl.dart';
  static const _notCorrectNameFailure = 'Incorrect Intl name, should be';
  static const _notCorrectNameCorrectionComment = 'Rename';
  static const _notExistsNameFailure = 'Argument `name` does not exists';

  PreferIntlNameRule({Map<String, Object> config = const {}})
      : super(
            id: ruleId,
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

    return [
      ...visitor.issues.whereType<_NotCorrectNameIssue>().map((issue) {
        final correction =
            "'${_NotCorrectNameIssue.getNewValue(issue.className, issue.variableName)}'";

        return createIssue(
          this,
          '$_notCorrectNameFailure $correction',
          correction,
          _notCorrectNameCorrectionComment,
          sourceUrl,
          sourceContent,
          unit.lineInfo,
          issue.node,
        );
      }),
      ...visitor.issues
          .whereType<_NotExistNameIssue>()
          .map((issue) => createIssue(
                this,
                _notExistsNameFailure,
                null,
                null,
                sourceUrl,
                sourceContent,
                unit.lineInfo,
                issue.node,
              )),
    ];
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

    final className = node.parent.as<NamedCompilationUnitMember>().name.name;

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

  void _checkVariables(String className, VariableDeclarationList variables) {
    for (final variable in variables.variables) {
      final initializer = variable.initializer.as<MethodInvocation>();
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

  String _getClassName(MethodDeclaration node) {
    final name = node.parent?.as<NamedCompilationUnitMember>()?.name?.name;

    return name ?? node.parent?.as<ExtensionDeclaration>()?.name?.name;
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

    final nameExpression = methodInvocation.argumentList?.arguments
        ?.whereType<NamedExpression>()
        ?.where((argument) => argument.name.label.name == 'name')
        ?.firstOrDefault()
        ?.expression
        ?.as<SimpleStringLiteral>();

    if (nameExpression == null) {
      _issues.add(_NotExistNameIssue(methodInvocation.methodName));
    } else if (nameExpression.value !=
        _NotCorrectNameIssue.getNewValue(className, variableName)) {
      _issues
          .add(_NotCorrectNameIssue(className, variableName, nameExpression));
    }
  }
}

@immutable
abstract class _Issue {
  final AstNode node;

  const _Issue(
    this.node,
  );
}

@immutable
class _NotCorrectNameIssue extends _Issue {
  final String className;
  final String variableName;

  const _NotCorrectNameIssue(
    this.className,
    this.variableName,
    AstNode node,
  ) : super(node);

  static String getNewValue(String className, String variableName) =>
      className != null ? '${className}_$variableName' : '$variableName';
}

@immutable
class _NotExistNameIssue extends _Issue {
  const _NotExistNameIssue(
    AstNode node,
  ) : super(node);
}
