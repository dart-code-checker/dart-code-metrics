import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
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
    final visitor = _Visitor();
    source.unit.visitChildren(visitor);

    final className = _formatClassName(visitor._declarations.first.name.name);
    final fileName = basenameWithoutExtension(source.path);

    if (fileName != className) {
      final issue = createIssue(
        rule: this,
        location: nodeLocation(
          node: visitor._declarations.first.name,
          source: source,
          withCommentOrMetadata: true,
        ),
        message: _NotMatchFileNameIssue.getMessage(),
      );

      return [issue];
    }

    return [];
  }
}

String _formatClassName(String className) {
  final exp = RegExp('(?<=[a-z])[A-Z]');
  final result =
      className.replaceAllMapped(exp, (m) => '_${m.group(0)!}').toLowerCase();

  return result;
}
