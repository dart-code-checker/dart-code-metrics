// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../../models/flutter_rule.dart';
import '../../rule_utils.dart';

part 'models/edge_insets_data.dart';
part 'models/edge_insets_param.dart';
part 'validator.dart';
part 'visitor.dart';

class PreferCorrectEdgeInsetsConstructorRule extends FlutterRule {
  static const ruleId = 'prefer-correct-edge-insets-constructor';
  static const _issueMessage = 'Prefer using correct EdgeInsets constructor.';

  PreferCorrectEdgeInsetsConstructorRule([
    Map<String, Object> config = const {},
  ]) : super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();
    final validator = _Validator();

    source.unit.visitChildren(visitor);
    validator.validate(visitor.expressions);

    return validator.expressions.entries
        .map((expression) => createIssue(
              rule: this,
              location: nodeLocation(
                node: expression.key,
                source: source,
              ),
              message: _issueMessage,
              replacement: _createReplacement(expression.value),
            ))
        .toList(growable: false);
  }

  Replacement? _createReplacement(String expression) => Replacement(
        comment: 'Prefer use $expression',
        replacement: expression,
      );
}
