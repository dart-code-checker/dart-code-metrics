// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../flutter_rule_utils.dart';
import '../../models/flutter_rule.dart';
import '../../rule_utils.dart';

part 'config_parser.dart';
part 'visitor.dart';

class PreferExtractingCallbacksRule extends FlutterRule {
  static const String ruleId = 'prefer-extracting-callbacks';

  static const _warningMessage =
      'Prefer extracting the callback to a separate widget method.';

  final Iterable<String> _ignoredArguments;

  PreferExtractingCallbacksRule([Map<String, Object> config = const {}])
      : _ignoredArguments = _ConfigParser.parseIgnoredArguments(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final _visitor = _Visitor(_ignoredArguments);

    source.unit.visitChildren(_visitor);

    return _visitor.expressions
        .map(
          (expression) => createIssue(
            rule: this,
            location: nodeLocation(
              node: expression,
              source: source,
            ),
            message: _warningMessage,
          ),
        )
        .toList(growable: false);
  }
}
