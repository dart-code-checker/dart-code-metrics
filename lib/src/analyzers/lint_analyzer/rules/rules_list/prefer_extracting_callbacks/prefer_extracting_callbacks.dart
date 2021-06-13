import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../flutter_rule_utils.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';
part 'config_parser.dart';

class PreferExtractingCallbacksRule extends Rule {
  static const String ruleId = 'prefer-extracting-callbacks';

  static const _warningMessage =
      'Prefer extracting the callback to a separate widget method.';

  final Iterable<String> _ignoredArguments;

  PreferExtractingCallbacksRule([Map<String, Object> config = const {}])
      : _ignoredArguments = _ConfigParser.parseIgnoredArguments(config),
        super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Prefer extracting callbacks',
            brief:
                'Warns about inline callbacks in a widget tree and suggest to extract them to a widget method.',
          ),
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
