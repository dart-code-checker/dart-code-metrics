// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:collection/collection.dart';

import '../../../../../utils/flutter_types_utils.dart';
import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../../models/flame_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class CorrectGameInstantiatingRule extends FlameRule {
  static const String ruleId = 'correct-game-instantiating';

  static const _warningMessage =
      'Incorrect game instantiation. The game will reset on each rebuild.';
  static const _correctionMessage = "Replace with 'controlled'.";

  CorrectGameInstantiatingRule([Map<String, Object> config = const {}])
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

    return visitor.info
        .map((info) => createIssue(
              rule: this,
              location: nodeLocation(node: info.node, source: source),
              message: _warningMessage,
              replacement: _createReplacement(info),
            ))
        .toList(growable: false);
  }

  Replacement? _createReplacement(_InstantiationInfo info) {
    if (info.isStateless) {
      final arguments = info.node.argumentList.arguments.map((arg) {
        if (arg is NamedExpression && arg.name.label.name == 'game') {
          final expression = arg.expression;
          if (expression is InstanceCreationExpression) {
            final name =
                expression.staticType?.getDisplayString(withNullability: false);
            if (name != null) {
              return 'gameFactory: $name.new,';
            }
          }
        }

        return arg.toSource();
      });

      return Replacement(
        replacement: 'GameWidget.controlled$arguments;',
        comment: _correctionMessage,
      );
    }

    return null;
  }
}
