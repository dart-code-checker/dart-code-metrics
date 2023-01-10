// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class ListAllEquatableFieldsRule extends CommonRule {
  static const ruleId = 'list-all-equatable-fields';

  ListAllEquatableFieldsRule([
    Map<String, Object> config = const {},
  ]) : super(
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
              location: nodeLocation(node: declaration.node, source: source),
              message: declaration.errorMessage,
            ))
        .toList(growable: false);
  }
}
