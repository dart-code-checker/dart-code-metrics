// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'config_parser.dart';
part 'visitor.dart';

class PreferCorrectTestFileNameRule extends CommonRule {
  static const String ruleId = 'prefer-correct-test-file-name';

  static const _warningMessage = 'Test file name should end with ';

  final String _fileNamePattern;

  PreferCorrectTestFileNameRule([Map<String, Object> config = const {}])
      : _fileNamePattern = _ConfigParser.parseNamePattern(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
          includes: hasIncludes(config) ? readIncludes(config) : ['test/**'],
        );

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json[_ConfigParser._namePatternConfig] = _fileNamePattern;

    return json;
  }

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(source.path, _fileNamePattern);

    source.unit.visitChildren(visitor);

    return visitor.declaration
        .map((declaration) => createIssue(
              rule: this,
              location: nodeLocation(node: declaration, source: source),
              message: '$_warningMessage$_fileNamePattern',
            ))
        .toList(growable: false);
  }
}
