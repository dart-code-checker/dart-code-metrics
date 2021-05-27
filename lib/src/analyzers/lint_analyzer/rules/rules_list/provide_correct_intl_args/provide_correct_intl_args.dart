import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/node_utils.dart';
import '../../../../../utils/object_extensions.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../base_visitors/intl_base_visitor.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class ProvideCorrectIntlArgsRule extends Rule {
  static const String ruleId = 'provide-correct-intl-args';

  static const _intlPackageUrl = 'package:intl/intl.dart';

  ProvideCorrectIntlArgsRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Provide correct intl args',
            brief:
                'Warns when the Intl.message() invocation has incorrect args.',
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

    return visitor.issues
        .map((issue) => createIssue(
              rule: this,
              location: nodeLocation(
                node: issue.node,
                source: source,
                withCommentOrMetadata: true,
              ),
              message: issue.nameFailure!,
            ))
        .toList();
  }
}
