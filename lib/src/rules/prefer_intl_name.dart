import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

import '../models/code_issue.dart';
import '../models/code_issue_severity.dart';
import '../models/source.dart';
import '../rules/rule_utils.dart';
import '../utils/iterable_extensions.dart';
import '../utils/object_extensions.dart';
import 'base_rule.dart';
import 'intl_base/intl_base_visitor.dart';

class PreferIntlNameRule extends BaseRule {
  static const String ruleId = 'prefer-intl-name';
  static const _documentationUrl = 'https://git.io/JJwmc';

  static const _intlPackageUrl = 'package:intl/intl.dart';
  static const _notCorrectNameFailure = 'Incorrect Intl name, should be';
  static const _notCorrectNameCorrectionComment = 'Rename';
  static const _notExistsNameFailure = 'Argument `name` does not exists';

  PreferIntlNameRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentation: Uri.parse(_documentationUrl),
          severity: CodeIssueSeverity.fromJson(config['severity'] as String) ??
              CodeIssueSeverity.warning,
        );

  @override
  Iterable<CodeIssue> check(Source source) {
    final hasIntlDirective = source.compilationUnit.directives
        .whereType<ImportDirective>()
        .any((directive) => directive.uri.stringValue == _intlPackageUrl);

    if (!hasIntlDirective) {
      return [];
    }

    final visitor = _Visitor();
    source.compilationUnit.visitChildren(visitor);

    return [
      ...visitor.issues.whereType<_NotCorrectNameIssue>().map((issue) {
        final correction =
            "'${_NotCorrectNameIssue.getNewValue(issue.className, issue.variableName)}'";

        return createIssue(
          this,
          '$_notCorrectNameFailure $correction',
          correction,
          _notCorrectNameCorrectionComment,
          source.url,
          source.content,
          source.compilationUnit.lineInfo,
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
                source.url,
                source.content,
                source.compilationUnit.lineInfo,
                issue.node,
              )),
    ];
  }
}

class _Visitor extends IntlBaseVisitor {
  @override
  void checkMethodInvocation(
    MethodInvocation methodInvocation, {
    String className,
    String variableName,
    FormalParameterList parameterList,
  }) {
    final nameExpression = methodInvocation.argumentList?.arguments
        ?.whereType<NamedExpression>()
        ?.where((argument) => argument.name.label.name == 'name')
        ?.firstOrDefault()
        ?.expression
        ?.as<SimpleStringLiteral>();

    if (nameExpression == null) {
      addIssue(_NotExistNameIssue(methodInvocation.methodName));
    } else if (nameExpression.value !=
        _NotCorrectNameIssue.getNewValue(className, variableName)) {
      addIssue(_NotCorrectNameIssue(className, variableName, nameExpression));
    }
  }
}

@immutable
class _NotCorrectNameIssue extends IntlBaseIssue {
  final String className;
  final String variableName;

  const _NotCorrectNameIssue(
    this.className,
    this.variableName,
    AstNode node,
  ) : super(node);

  static String getNewValue(String className, String variableName) =>
      className != null ? '${className}_$variableName' : variableName;
}

@immutable
class _NotExistNameIssue extends IntlBaseIssue {
  const _NotExistNameIssue(
    AstNode node,
  ) : super(node);
}
