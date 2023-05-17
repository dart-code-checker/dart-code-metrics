// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

// Inspired by ESLint (https://eslint.org/docs/rules/newline-before-return)

class NewlineBeforeReturnRule extends CommonRule {
  static const String ruleId = 'newline-before-return';

  static const _warning = 'Missing blank line before return.';

  NewlineBeforeReturnRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    return visitor.statements
        // return statement is in a block
        .where((statement) => statement.parent is Block)
        // return statement isn't first token in a block
        .where((statement) =>
            statement.returnKeyword.previous != statement.parent?.beginToken)
        .where((statement) {
          final lineInfo = source.lineInfo;

          final previousTokenLine = lineInfo
              .getLocation(statement.returnKeyword.previous!.end)
              .lineNumber;
          final tokenLine = lineInfo
              .getLocation(
                _optimalToken(statement.returnKeyword, lineInfo).offset,
              )
              .lineNumber;

          return !(tokenLine > previousTokenLine + 1);
        })
        .map((statement) => createIssue(
              rule: this,
              location: nodeLocation(node: statement, source: source),
              message: _warning,
            ))
        .toList(growable: false);
  }
}

Token _optimalToken(Token token, LineInfo lineInfo) {
  var optimalToken = token;

  var commentToken = _latestCommentToken(token);
  while (commentToken != null &&
      lineInfo.getLocation(commentToken.end).lineNumber + 1 >=
          lineInfo.getLocation(optimalToken.offset).lineNumber) {
    optimalToken = commentToken;
    commentToken = commentToken.previous;
  }

  return optimalToken;
}

Token? _latestCommentToken(Token token) {
  Token? latestCommentToken = token.precedingComments;
  while (latestCommentToken?.next != null) {
    latestCommentToken = latestCommentToken?.next;
  }

  return latestCommentToken;
}
