// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';

import '../../../../../utils/flame_type_utils.dart';
import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/flame_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class AvoidRedundantAsyncOnLoadRule extends FlameRule {
  static const String ruleId = 'avoid-redundant-async-on-load';

  static const _warningMessage = "Avoid unnecessary async 'onLoad'.";

  AvoidRedundantAsyncOnLoadRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    return visitor.declarations
        .map((declaration) => createIssue(
              rule: this,
              location: nodeLocation(node: declaration, source: source),
              message: _warningMessage,
            ))
        .toList(growable: false);
  }
}
