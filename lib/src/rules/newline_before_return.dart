import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';

import 'base_rule.dart';
import 'rule_utils.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/newline-before-return/)

class NewlineBeforeReturnRule extends BaseRule {
  static const _failure = 'Missing blank line before return';

  const NewlineBeforeReturnRule()
      : super(
          id: 'newline-before-return',
          severity: CodeIssueSeverity.style,
        );

  @override
  Iterable<CodeIssue> check(
      CompilationUnit unit, Uri sourceUrl, String sourceContent) {
    final _visitor = _Visitor();

    unit.visitChildren(_visitor);

    return _visitor.statements
        // return statement is in a block
        .where((statement) =>
            statement.parent != null && statement.parent is Block)
        // return statement isn't first token in a block
        .where((statement) =>
            statement.returnKeyword.previous != statement.parent.beginToken)
        .where((statement) {
          final previousTokenLine = unit.lineInfo
              .getLocation(statement.returnKeyword.previous.end)
              .lineNumber;
          final tokenLine = unit.lineInfo
              .getLocation(
                  _optimalToken(statement.returnKeyword, unit.lineInfo).offset)
              .lineNumber;

          return !(tokenLine > previousTokenLine + 1);
        })
        .map((statement) => createIssue(this, _failure, null, null, sourceUrl,
            sourceContent, unit.lineInfo, statement))
        .toList();
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

  Token _latestCommentToken(Token token) {
    // todo: remove ignore after migrate on analyzer 0.39.3
    // ignore: omit_local_variable_types
    Token latestCommentToken = token?.precedingComments;
    while (latestCommentToken?.next != null) {
      latestCommentToken = latestCommentToken.next;
    }

    return latestCommentToken;
  }
}

class _Visitor extends RecursiveAstVisitor<Object> {
  final _statements = <ReturnStatement>[];

  Iterable<ReturnStatement> get statements => _statements;

  @override
  void visitReturnStatement(ReturnStatement node) {
    super.visitReturnStatement(node);
    _statements.add(node);
  }
}
