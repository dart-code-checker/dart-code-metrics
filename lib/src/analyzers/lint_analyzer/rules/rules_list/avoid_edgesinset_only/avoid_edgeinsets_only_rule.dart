// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:dart_code_metrics/lint_analyzer.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/flutter_rule.dart';
import '../../rule_utils.dart';
import '../prefer_correct_edge_insets_constructor/prefer_correct_edge_insets_constructor_rule.dart';

part 'visitor.dart';
part 'validator.dart';

class AvoidEdgeInsetsOnlyRule extends FlutterRule {
  static const String ruleId = 'avoid-edgeinsets-only';

  static const _warningMessage = 'EdgeInsets.only is not allowed due to Arabic support, use EdgeInsetsDirectional instead';
  static const _replacementMessage = "Replace with EdgeInsetsDirectional.only";

  AvoidEdgeInsetsOnlyRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.error),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();
    final validator = _Validator();
    source.unit.visitChildren(visitor);
    validator.validate(visitor.edgeInsetOnlyExpressions);


    return validator.expressions.entries
        .map((expression) => createIssue(
              rule: this,
              location: nodeLocation(
                node: expression.key,
                source: source,
              ),
              message: _warningMessage,
      replacement: Replacement(
        comment: _replacementMessage,
        replacement: expression.value,
      ),
            ))
        .toList(growable: false);
  }
}
