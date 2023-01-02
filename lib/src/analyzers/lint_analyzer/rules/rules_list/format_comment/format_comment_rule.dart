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
part 'visitor.dart';

class FormatCommentRule extends CommonRule {
  static const String ruleId = 'format-comment';

  static const _warning = 'Prefer formatting comments like sentences.';

  /// The patterns to ignore. They are used to ignore and not lint comments that
  /// match at least one of them.
  final Iterable<RegExp> _ignoredPatterns;

  final bool _onlyDocComments;

  FormatCommentRule([Map<String, Object> config = const {}])
      : _ignoredPatterns = _ConfigParser.parseIgnoredPatterns(config),
        _onlyDocComments = _ConfigParser.parseOnlyDocComments(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json[_ConfigParser._ignoredPatternsConfig] =
        _ignoredPatterns.map((exp) => exp.pattern).toList();
    json[_ConfigParser._onlyDocComments] = _onlyDocComments;

    return json;
  }

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(
      _ignoredPatterns,
      _onlyDocComments,
    )..checkRegularComments(source.unit.root);

    source.unit.visitChildren(visitor);

    final issues = <Issue>[];

    for (final comment in visitor.comments) {
      if (comment is _DocCommentInfo) {
        issues.add(createIssue(
          rule: this,
          location: nodeLocation(node: comment.comment, source: source),
          message: _warning,
          replacement: _docCommentReplacement(comment.comment),
        ));
      }
      if (comment is _RegularCommentInfo) {
        issues.addAll(
          comment.tokens
              .map((token) => createIssue(
                    rule: this,
                    location: nodeLocation(node: token, source: source),
                    message: _warning,
                    replacement: _regularCommentReplacement(
                      token,
                      comment.tokens.length == 1,
                    ),
                  ))
              .toList(),
        );
      }
    }

    return issues;
  }

  Replacement? _docCommentReplacement(Comment comment) {
    if (comment.tokens.length == 1) {
      final commentToken = comment.tokens.first;
      final text = commentToken.toString();
      final commentText = formatComment(text.substring(3, text.length));

      return Replacement(
        comment: 'Format comment.',
        replacement: '/// $commentText',
      );
    }

    return null;
  }

  Replacement? _regularCommentReplacement(Token token, bool isSingle) {
    if (isSingle) {
      final text = token.toString();
      final commentText = formatComment(text.substring(2, text.length));

      return Replacement(
        comment: 'Format comment.',
        replacement: '// $commentText',
      );
    }

    return null;
  }

  String formatComment(String res) => replaceEnd(res.trim().capitalize());

  String replaceEnd(String text) =>
      !_punctuation.contains(text[text.length - 1]) ? '$text.' : text;
}
