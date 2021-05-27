import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/node_utils.dart';
import '../../../../../utils/object_extensions.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../../base_visitors/intl_base_visitor.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class PreferIntlNameRule extends Rule {
  static const String ruleId = 'prefer-intl-name';

  static const _intlPackageUrl = 'package:intl/intl.dart';
  static const _notCorrectNameFailure = 'Incorrect Intl name, should be';
  static const _notCorrectNameCorrectionComment = 'Rename';
  static const _notExistsNameFailure = 'Argument `name` does not exists';

  PreferIntlNameRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Prefer intl name',
            brief:
                'Recommends to use ClassName_ClassMemberName pattern for Intl methods name argument',
          ),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final hasIntlDirective = source.unit.directives
        .whereType<ImportDirective>()
        .any((directive) => directive.uri.stringValue == _intlPackageUrl);

    if (!hasIntlDirective) {
      return [];
    }

    final visitor = _Visitor();
    source.unit.visitChildren(visitor);

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
