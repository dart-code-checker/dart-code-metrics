import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class PreferMatchFileName extends CommonRule {
  static const String ruleId = 'prefer-match-file-name';
  static const _notMatchNameFailure =
      'File name does not match with first class name';
  static final _onlySymbolsRegex = RegExp('[^a-zA-Z0-9]');

  PreferMatchFileName([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Prefer match file name',
            brief: 'Warns when file name does not match class name.',
          ),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  bool _hasMatchName(String path, String className) {
    final classNameFormatted =
        className.replaceAll(_onlySymbolsRegex, '').toLowerCase();

    return classNameFormatted ==
        basename(path).split('.').first
            .replaceAll(_onlySymbolsRegex, '')
            .toLowerCase();
  }

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();
    source.unit.visitChildren(visitor);

    final _issue = <Issue>[];

    if (visitor.declaration.isNotEmpty &&
        !_hasMatchName(source.path, visitor.declaration.first.name)) {
      final issue = createIssue(
        rule: this,
        location: nodeLocation(
          node: visitor.declaration.first,
          source: source,
          withCommentOrMetadata: true,
        ),
        message: _notMatchNameFailure,
      );

      _issue.add(issue);
    }

    return _issue;
  }
}
