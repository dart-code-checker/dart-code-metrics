import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

import '../../models/issue.dart';
import '../../models/rule_documentation.dart';
import '../../models/severity.dart';
import '../../obsoleted/models/internal_resolved_unit_result.dart';
import '../../utils/node_utils.dart';
import '../../utils/rule_utils.dart';
import '../rule.dart';

part 'return_statement_visitor.dart';

// Inspired by ESLint (https://eslint.org/docs/rules/newline-before-return)

const _documentation = RuleDocumentation(
  name: 'New Line Before Return',
  brief: 'Enforces blank line between statements and return in a block',
);

const _failure = 'Missing blank line before return';

class NewlineBeforeReturnRule extends Rule {
  static const String ruleId = 'newline-before-return';

  NewlineBeforeReturnRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentation: _documentation,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
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
              message: _failure,
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
