import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/flutter_types_utils.dart';
import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/flutter_rule.dart';
import '../../rule_utils.dart';

part 'helpers.dart';
part 'visitor.dart';

class UseSetStateSynchronouslyRule extends FlutterRule {
  static const ruleId = 'use-setstate-synchronously';
  static const _warning =
      "Avoid calling 'setState' past an await point without checking if the widget is mounted.";

  UseSetStateSynchronouslyRule([Map<String, Object> options = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(options, Severity.warning),
          excludes: readExcludes(options),
          includes: readIncludes(options),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();
    source.unit.visitChildren(visitor);

    return visitor.nodes
        .map((node) => createIssue(
              rule: this,
              location: nodeLocation(node: node, source: source),
              message: _warning,
            ))
        .toList(growable: false);
  }
}
