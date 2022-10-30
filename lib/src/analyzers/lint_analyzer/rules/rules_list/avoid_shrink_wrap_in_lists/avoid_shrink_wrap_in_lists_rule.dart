// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:collection/collection.dart';

import '../../../../../utils/flutter_types_utils.dart';
import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/flutter_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class AvoidShrinkWrapInListsRule extends FlutterRule {
  static const String ruleId = 'avoid-shrink-wrap-in-lists';

  static const _warning =
      'Avoid using ListView with shrinkWrap, since it might degrade the performance. Consider using slivers instead.';

  AvoidShrinkWrapInListsRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.performance),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    return visitor.expressions
        .map((expression) => createIssue(
              rule: this,
              location: nodeLocation(
                node: expression,
                source: source,
              ),
              message: _warning,
            ))
        .toList(growable: false);
  }
}
