// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as p;

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../node_utils.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class PreferMatchFileNameRule extends CommonRule {
  static const String ruleId = 'prefer-match-file-name';
  static final _onlySymbolsRegex = RegExp('[^a-zA-Z0-9]');

  PreferMatchFileNameRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();
    source.unit.visitChildren(visitor);

    final _issue = <Issue>[];

    if (visitor.declaration.isNotEmpty &&
        !_hasMatchName(source.path, visitor.declaration.first.name)) {
      final node = visitor.declaration.first;
      final nodeType = humanReadableNodeType(node.parent).toLowerCase();

      final issue = createIssue(
        rule: this,
        location: nodeLocation(node: node, source: source),
        message: 'File name does not match with first $nodeType name.',
      );

      _issue.add(issue);
    }

    return _issue;
  }

  bool _hasMatchName(String path, String identifierName) {
    final identifierNameFormatted =
        identifierName.replaceAll(_onlySymbolsRegex, '').toLowerCase();

    final fileNameFormatted = p
        .basename(path)
        .split('.')
        .first
        .replaceAll(_onlySymbolsRegex, '')
        .toLowerCase();

    return identifierNameFormatted == fileNameFormatted;
  }
}
