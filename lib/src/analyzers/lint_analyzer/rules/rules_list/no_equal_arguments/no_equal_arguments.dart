import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'config_parser.dart';
part 'visitor.dart';

class NoEqualArgumentsRule extends Rule {
  static const String ruleId = 'no-equal-arguments';

  static const _warningMessage = 'The argument has already been passed.';

  final Iterable<String> _ignoredParameters;

  NoEqualArgumentsRule([Map<String, Object> config = const {}])
      : _ignoredParameters = _ConfigParser.parseIgnoredParameters(config),
        super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'No equal arguments',
            brief:
                'Warns when equal arguments passed to a function or method invocation.',
          ),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final _visitor = _Visitor(_ignoredParameters);

    source.unit.visitChildren(_visitor);

    return _visitor.arguments
        .map((argument) => createIssue(
              rule: this,
              location: nodeLocation(
                node: argument,
                source: source,
                withCommentOrMetadata: true,
              ),
              message: _warningMessage,
            ))
        .toList(growable: false);
  }
}
