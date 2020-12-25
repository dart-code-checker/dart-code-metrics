import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

import '../models/code_issue.dart';
import '../models/code_issue_severity.dart';
import '../models/source.dart';
import 'base_rule.dart';
import 'rule_utils.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/newline-before-return/)

class NewlineBeforeReturnRule extends BaseRule {
  static const String ruleId = 'newline-before-return';
  static const _documentationUrl = 'https://git.io/JfDiO';

  static const _failure = 'Missing blank line before return';

  NewlineBeforeReturnRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentation: Uri.parse(_documentationUrl),
          severity: CodeIssueSeverity.fromJson(config['severity'] as String) ??
              CodeIssueSeverity.style,
        );

  @override
  Iterable<CodeIssue> check(Source source) {
    final _visitor = _Visitor();

    source.compilationUnit.visitChildren(_visitor);

    return _visitor.statements
        // return statement is in a block
        .where((statement) =>
            statement.parent != null && statement.parent is Block)
        // return statement isn't first token in a block
        .where((statement) =>
            statement.returnKeyword.previous != statement.parent.beginToken)
        .where((statement) {
          final previousTokenLine = source.compilationUnit.lineInfo
              .getLocation(statement.returnKeyword.previous.end)
              .lineNumber;
          final tokenLine = source.compilationUnit.lineInfo
              .getLocation(_optimalToken(
                statement.returnKeyword,
                source.compilationUnit.lineInfo,
              ).offset)
              .lineNumber;

          return !(tokenLine > previousTokenLine + 1);
        })
        .map((statement) => createIssue(
              this,
              _failure,
              null,
              null,
              source.url,
              source.content,
              source.compilationUnit.lineInfo,
              statement,
            ))
        .toList(growable: false);
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
    Token latestCommentToken = token?.precedingComments;
    while (latestCommentToken?.next != null) {
      latestCommentToken = latestCommentToken.next;
    }

    return latestCommentToken;
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final _statements = <ReturnStatement>[];

  Iterable<ReturnStatement> get statements => _statements;

  @override
  void visitReturnStatement(ReturnStatement node) {
    super.visitReturnStatement(node);
    _statements.add(node);
  }
}
