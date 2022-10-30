// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:collection/collection.dart';

import '../../../../../utils/node_utils.dart';
import '../../../../../utils/string_extensions.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/angular_rule.dart';
import '../../rule_utils.dart';

part 'config_parser.dart';
part 'visitor.dart';

class ComponentAnnotationArgumentsOrderingRule extends AngularRule {
  static const ruleId = 'component-annotation-arguments-ordering';

  static const _warningMessage = 'should be before';

  final List<_ArgumentGroup> _groupsOrder;

  ComponentAnnotationArgumentsOrderingRule([
    Map<String, Object> config = const {},
  ])  : _groupsOrder = _ConfigParser.parseOrder(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(_groupsOrder);

    final argumentsInfo = [
      for (final entry in source.unit.childEntities)
        if (entry is ClassDeclaration) ...entry.accept(visitor)!,
    ];

    return argumentsInfo.where((info) => info.argumentOrder.isWrong).map(
          (info) => createIssue(
            rule: this,
            location: nodeLocation(node: info.argument, source: source),
            message:
                'Arguments group ${info.argumentOrder.argumentGroup.name} $_warningMessage ${info.argumentOrder.previousArgumentGroup?.name}.',
          ),
        );
  }
}
