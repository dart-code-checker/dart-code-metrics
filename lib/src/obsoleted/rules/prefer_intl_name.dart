import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../../models/issue.dart';
import '../../models/replacement.dart';
import '../../models/severity.dart';
import '../../utils/node_utils.dart';
import '../../utils/rule_utils.dart';
import '../utils/object_extensions.dart';
import 'intl_base/intl_base_visitor.dart';
import 'obsolete_rule.dart';

class PreferIntlNameRule extends ObsoleteRule {
  static const String ruleId = 'prefer-intl-name';
  static const _documentationUrl = 'https://git.io/JJwmc';

  static const _intlPackageUrl = 'package:intl/intl.dart';
  static const _notCorrectNameFailure = 'Incorrect Intl name, should be';
  static const _notCorrectNameCorrectionComment = 'Rename';
  static const _notExistsNameFailure = 'Argument `name` does not exists';

  PreferIntlNameRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentationUrl: Uri.parse(_documentationUrl),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(ResolvedUnitResult source) {
    final hasIntlDirective = source.unit?.directives
        .whereType<ImportDirective>()
        .any((directive) => directive.uri.stringValue == _intlPackageUrl);

    if (hasIntlDirective == null || !hasIntlDirective) {
      return [];
    }

    final visitor = _Visitor();
    source.unit?.visitChildren(visitor);

    return [
      ...visitor.issues.whereType<_NotCorrectNameIssue>().map((issue) {
        final correction =
            "'${_NotCorrectNameIssue.getNewValue(issue.className, issue.variableName)}'";

        return createIssue(
          rule: this,
          location: nodeLocation(
            node: issue.node,
            source: source,
            withCommentOrMetadata: true,
          ),
          message: '$_notCorrectNameFailure $correction',
          replacement: Replacement(
            comment: _notCorrectNameCorrectionComment,
            replacement: correction,
          ),
        );
      }),
      ...visitor.issues
          .whereType<_NotExistNameIssue>()
          .map((issue) => createIssue(
                rule: this,
                location: nodeLocation(
                  node: issue.node,
                  source: source,
                  withCommentOrMetadata: true,
                ),
                message: _notExistsNameFailure,
              )),
    ];
  }
}

class _Visitor extends IntlBaseVisitor {
  @override
  void checkMethodInvocation(
    MethodInvocation methodInvocation, {
    String? className,
    String? variableName,
    FormalParameterList? parameterList,
  }) {
    final nameExpression = methodInvocation.argumentList.arguments
        .whereType<NamedExpression>()
        .where((argument) => argument.name.label.name == 'name')
        .firstOrNull
        ?.expression
        .as<SimpleStringLiteral>();

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
  final String? className;
  final String? variableName;

  const _NotCorrectNameIssue(
    this.className,
    this.variableName,
    AstNode node,
  ) : super(node);

  static String? getNewValue(String? className, String? variableName) =>
      className != null ? '${className}_$variableName' : variableName;
}

@immutable
class _NotExistNameIssue extends IntlBaseIssue {
  const _NotExistNameIssue(
    AstNode node,
  ) : super(node);
}
