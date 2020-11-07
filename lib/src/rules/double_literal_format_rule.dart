import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:meta/meta.dart';

import '../models/code_issue.dart';
import '../models/code_issue_severity.dart';
import '../models/source.dart';
import 'base_rule.dart';
import 'rule_utils.dart';

class DoubleLiteralFormatRule extends BaseRule {
  static const String ruleId = 'double-literal-format';
  static const _documentationUrl = 'https://git.io/Jf3MH';

  static const _failureLeadingZero =
      "Double literal shouldn't have redundant leading '0'.";
  static const _correctionCommentLeadingZero = "Remove redundant leading '0'";

  static const _failureLeadingDecimal =
      "Double literal shouldn't begin with '.'.";
  static const _correctionCommentLeadingDecimal = "Add missing leading '0'";

  static const _failureTrailingZero =
      "Double literal shouldn't have a trailing '0'.";
  static const _correctionCommentTrailingZero = "Remove redundant trailing '0'";

  DoubleLiteralFormatRule({Map<String, Object> config = const {}})
      : super(
            id: ruleId,
            documentation: Uri.parse(_documentationUrl),
            severity:
                CodeIssueSeverity.fromJson(config['severity'] as String) ??
                    CodeIssueSeverity.style);

  @override
  Iterable<CodeIssue> check(Source source) {
    final _visitor = _Visitor();

    source.compilationUnit.visitChildren(_visitor);

    final issues = <CodeIssue>[];

    for (final node in _visitor.literals) {
      final lexeme = node.literal.lexeme;

      if (detectLeadingZero(lexeme)) {
        issues.add(createIssue(
            this,
            _failureLeadingZero,
            leadingZeroCorrection(lexeme),
            _correctionCommentLeadingZero,
            source.url,
            source.content,
            source.compilationUnit.lineInfo,
            node));
      } else if (detectLeadingDecimal(lexeme)) {
        issues.add(createIssue(
            this,
            _failureLeadingDecimal,
            leadingDecimalCorrection(lexeme),
            _correctionCommentLeadingDecimal,
            source.url,
            source.content,
            source.compilationUnit.lineInfo,
            node));
      } else if (detectTrailingZero(lexeme)) {
        issues.add(createIssue(
            this,
            _failureTrailingZero,
            trailingZeroCorrection(lexeme),
            _correctionCommentTrailingZero,
            source.url,
            source.content,
            source.compilationUnit.lineInfo,
            node));
      }
    }

    return issues;
  }
}

class _Visitor extends RecursiveAstVisitor<Object> {
  final _literals = <DoubleLiteral>[];

  Iterable<DoubleLiteral> get literals => _literals;

  @override
  void visitDoubleLiteral(DoubleLiteral node) {
    _literals.add(node);
    super.visitDoubleLiteral(node);
  }
}

@visibleForTesting
bool detectLeadingZero(String lexeme) =>
    lexeme.startsWith('0') && lexeme[1] != '.';

@visibleForTesting
String leadingZeroCorrection(String lexeme) => !detectLeadingZero(lexeme)
    ? lexeme
    : leadingZeroCorrection(lexeme.substring(1));

@visibleForTesting
bool detectLeadingDecimal(String lexeme) => lexeme.startsWith('.');

@visibleForTesting
String leadingDecimalCorrection(String lexeme) =>
    !detectLeadingDecimal(lexeme) ? lexeme : '0$lexeme';

@visibleForTesting
bool detectTrailingZero(String lexeme) {
  final mantissa = lexeme.split('e').first;

  return mantissa.contains('.') &&
      mantissa.endsWith('0') &&
      mantissa.split('.').last != '0';
}

@visibleForTesting
String trailingZeroCorrection(String lexeme) {
  if (!detectTrailingZero(lexeme)) {
    return lexeme;
  } else {
    final mantissa = lexeme.split('e').first;

    return trailingZeroCorrection(lexeme.replaceFirst(
        mantissa, mantissa.substring(0, mantissa.length - 1)));
  }
}
