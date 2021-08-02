import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart';

import '../../../../../utils/node_utils.dart';
import '../../../../../utils/string_extension.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

const _issueMessage = 'File name does not match with first class name';

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
    final visitor = _Visitor();
    source.unit.visitChildren(visitor);

    return visitor.getIssueList(source);
  }
}
