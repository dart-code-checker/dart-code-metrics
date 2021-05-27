import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'config_parser.dart';
part 'visitor.dart';

class AvoidReturningWidgetsRule extends Rule {
  static const String ruleId = 'avoid-returning-widgets';

  static const _warningMessage = 'Avoid returning widgets from a function.';

  final Iterable<String> _ignoredNames;
  final Iterable<String> _ignoredAnnotations;

  AvoidReturningWidgetsRule([Map<String, Object> config = const {}])
      : _ignoredNames = _ConfigParser.getIgnoredNames(config),
        _ignoredAnnotations = _ConfigParser.getIgnoredAnnotations(config),
        super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Avoid returning widgets',
            brief:
                'Warns when a method or function returns a Widget or subclass of a Widget.',
          ),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final _visitor = _Visitor(_ignoredNames, _ignoredAnnotations);

    source.unit.visitChildren(_visitor);

    return _visitor.declarations
        .map((declaration) => createIssue(
              rule: this,
              location: nodeLocation(
                node: declaration,
                source: source,
                withCommentOrMetadata: true,
              ),
              message: _warningMessage,
            ))
        .toList(growable: false);
  }
}
