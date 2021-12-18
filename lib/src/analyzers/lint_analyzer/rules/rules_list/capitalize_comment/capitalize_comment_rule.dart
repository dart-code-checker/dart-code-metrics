// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../../lint_analyzer.dart';
import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class CapitalizeCommentRule extends CommonRule {
  static const String ruleId = 'capitalize-comment';

  static const _warning = 'Prefer format comments like sentences';

  CapitalizeCommentRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    visitor.visitComments(source.unit.root);

    return visitor.comments
        .map((declaration) => createIssue(
              rule: this,
              location: nodeLocation(
                node: declaration,
                source: source,
              ),
              message: _warning,
              replacement: _createReplacement(declaration.toString()),
            ))
        .toList(growable: false);
  }

  Replacement _createReplacement(String comment) {
    var resultString = comment;
    // TODO(konoshenko): Process the case of TODO
    if (comment.startsWith('//')) {
      final subString = formatComment(comment.substring(2, comment.length));
      resultString = '// $subString';
    }
    if (comment.startsWith('/*')) {
      final subString = formatComment(comment.substring(2, comment.length - 2));
      resultString = '/* $subString */';
    }
    if (comment.startsWith('///')) {
      final subString = formatComment(comment.substring(3, comment.length));
      resultString = '/// $subString';
    }

    return Replacement(
      comment: 'Format comments like sentences',
      replacement: resultString,
    );
  }

  String formatComment(String res) => res.trim().capitalize().replaceEnd();
}

const _punctuation = ['.', ',', '!', '?'];

extension _StringExtension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';

  String replaceEnd() =>
      !_punctuation.contains(this[length - 1]) ? '$this.' : this;
}
