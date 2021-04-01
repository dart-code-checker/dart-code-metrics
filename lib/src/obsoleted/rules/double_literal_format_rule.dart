import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:meta/meta.dart';

import '../../models/issue.dart';
import '../../models/replacement.dart';
import '../../models/severity.dart';
import '../../utils/node_utils.dart';
import '../../utils/rule_utils.dart';
import 'obsolete_rule.dart';

class DoubleLiteralFormatRule extends ObsoleteRule {
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
          documentationUrl: Uri.parse(_documentationUrl),
          severity: readSeverity(config, Severity.style),
        );

  @override
  Iterable<Issue> check(ResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit?.visitChildren(_visitor);

    final issues = <Issue>[];

    for (final node in _visitor.literals) {
      final lexeme = node.literal.lexeme;

      if (detectLeadingZero(lexeme)) {
        issues.add(createIssue(
          rule: this,
          location: nodeLocation(
            node: node,
            source: source,
            withCommentOrMetadata: true,
          ),
          message: _failureLeadingZero,
          replacement: Replacement(
            comment: _correctionCommentLeadingZero,
            replacement: leadingZeroCorrection(lexeme),
          ),
        ));
      } else if (detectLeadingDecimal(lexeme)) {
        issues.add(createIssue(
          rule: this,
          location: nodeLocation(
            node: node,
            source: source,
            withCommentOrMetadata: true,
          ),
          message: _failureLeadingDecimal,
          replacement: Replacement(
            comment: _correctionCommentLeadingDecimal,
            replacement: leadingDecimalCorrection(lexeme),
          ),
        ));
      } else if (detectTrailingZero(lexeme)) {
        issues.add(createIssue(
          rule: this,
          location: nodeLocation(
            node: node,
            source: source,
            withCommentOrMetadata: true,
          ),
          message: _failureTrailingZero,
          replacement: Replacement(
            comment: _correctionCommentTrailingZero,
            replacement: trailingZeroCorrection(lexeme),
          ),
        ));
      }
    }

    return issues;
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
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
      mantissa,
      mantissa.substring(0, mantissa.length - 1),
    ));
  }
}
