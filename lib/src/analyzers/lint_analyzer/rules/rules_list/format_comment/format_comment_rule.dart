import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../../../utils/string_extensions.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';
import 'models/comment_info.dart';
import 'models/comment_type.dart';

part 'visitor.dart';

class FormatCommentRule extends CommonRule {
  static const String ruleId = 'format-comment';

  static const _warning = 'Prefer formatting comments like sentences.';

  FormatCommentRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor()..checkComments(source.unit.root);

    return [
      for (final comment in visitor.comments)
        createIssue(
          rule: this,
          location: nodeLocation(
            node: comment.token,
            source: source,
          ),
          message: _warning,
          replacement: _createReplacement(comment),
        ),
    ];
  }

  Replacement _createReplacement(CommentInfo commentType) {
    final comment = commentType.token.toString();
    var resultString = comment;

    switch (commentType.type) {
      case CommentType.base:
        final subString = formatComment(comment.substring(2, comment.length));
        resultString = '// $subString';
        break;
      case CommentType.documentation:
        final subString = formatComment(comment.substring(3, comment.length));
        resultString = '/// $subString';
        break;
      case CommentType.multiline:
        final subString =
            formatComment(comment.substring(2, comment.length - 2));
        resultString = '/* $subString*/';
    }

    return Replacement(
      comment: 'Format comments like sentences',
      replacement: resultString,
    );
  }

  String formatComment(String res) => res.trim().capitalize().replaceEnd();
}

const _punctuation = ['.', '!', '?'];

extension _StringExtension on String {
  String replaceEnd() =>
      !_punctuation.contains(this[length - 1]) ? '$this.' : this;
}
