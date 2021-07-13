import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../base_visitors/intl_base_visitor.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class PreferMatchFileName extends Rule {
  static const String ruleId = 'prefer_match_file_name';

  PreferMatchFileName([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Prefer match file name',
            brief: 'Warn when file name does not match class name',
          ),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(pathToFile: source.path);

    source.unit.visitChildren(visitor);

    return visitor._declarations.map((issue) => createIssue(
          rule: this,
          location: nodeLocation(
            node: issue.node,
            source: source,
            withCommentOrMetadata: true,
          ),
          message: _NotMatchFileNameIssue.getMessage(),
        ));
  }
}
