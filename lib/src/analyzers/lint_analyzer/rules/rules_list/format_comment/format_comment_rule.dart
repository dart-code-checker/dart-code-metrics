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

part 'config_parser.dart';
part 'models/comment_info.dart';
part 'models/comment_type.dart';
part 'visitor.dart';

class FormatCommentRule extends CommonRule {
  static const String ruleId = 'format-comment';

  static const _warning = 'Prefer formatting comments like sentences.';

  /// The patterns to ignore. They are used to ignore and not lint comments that
  /// match at least one of them.
  final Iterable<RegExp> _ignoredPatterns;

  FormatCommentRule([Map<String, Object> config = const {}])
      : _ignoredPatterns = _ConfigParser.getIgnoredPatterns(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(_ignoredPatterns)..checkComments(source.unit.root);

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

  Replacement _createReplacement(_CommentInfo commentInfo) {
    final commentToken = commentInfo.token;
    var resultString = commentToken.toString();

    switch (commentInfo.type) {
      case _CommentType.base:
        String commentText;

        final isHasNextComment = commentToken.next != null &&
            commentToken.next!.type == TokenType.SINGLE_LINE_COMMENT &&
            commentToken.next!.offset ==
                commentToken.offset + resultString.length + 1;
        final subString = resultString.substring(2, resultString.length);

        commentText = isHasNextComment
            ? subString.trim().capitalize()
            : formatComment(subString);

        resultString = '// $commentText';
        break;
      case _CommentType.documentation:
        final commentText =
            formatComment(resultString.substring(3, resultString.length));
        resultString = '/// $commentText';
        break;
    }

    return Replacement(
      comment: 'Format comment like sentences',
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
