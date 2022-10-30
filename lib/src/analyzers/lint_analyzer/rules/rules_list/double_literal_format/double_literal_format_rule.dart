// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/number-literal-format/)

class DoubleLiteralFormatRule extends CommonRule {
  static const String ruleId = 'double-literal-format';

  static const _warningLeadingZero =
      "Double literal shouldn't have redundant leading '0'.";
  static const _correctionCommentLeadingZero = "Remove redundant leading '0'.";

  static const _warningLeadingDecimal =
      "Double literal shouldn't begin with '.'.";
  static const _correctionCommentLeadingDecimal = "Add missing leading '0'.";

  static const _warningTrailingZero =
      "Double literal shouldn't have a trailing '0'.";
  static const _correctionCommentTrailingZero =
      "Remove redundant trailing '0'.";

  DoubleLiteralFormatRule([Map<String, Object> config = const {}])
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

    final issues = <Issue>[];

    for (final literal in visitor.literals) {
      final lexeme = literal.literal.lexeme;

      String? message;
      Replacement? replacement;

      if (_detectLeadingZero(lexeme)) {
        message = _warningLeadingZero;

        replacement = Replacement(
          comment: _correctionCommentLeadingZero,
          replacement: _leadingZeroCorrection(lexeme),
        );
      } else if (_detectLeadingDecimal(lexeme)) {
        message = _warningLeadingDecimal;

        replacement = Replacement(
          comment: _correctionCommentLeadingDecimal,
          replacement: _leadingDecimalCorrection(lexeme),
        );
      } else if (_detectTrailingZero(lexeme)) {
        message = _warningTrailingZero;

        replacement = Replacement(
          comment: _correctionCommentTrailingZero,
          replacement: _trailingZeroCorrection(lexeme),
        );
      }

      if (message != null) {
        issues.add(createIssue(
          rule: this,
          location: nodeLocation(node: literal, source: source),
          message: message,
          verboseMessage: replacement?.comment,
          replacement: replacement,
        ));
      }
    }

    return issues;
  }
}

bool _detectLeadingZero(String lexeme) =>
    lexeme.startsWith('0') && lexeme[1] != '.';

String _leadingZeroCorrection(String lexeme) => !_detectLeadingZero(lexeme)
    ? lexeme
    : _leadingZeroCorrection(lexeme.substring(1));

bool _detectLeadingDecimal(String lexeme) => lexeme.startsWith('.');

String _leadingDecimalCorrection(String lexeme) =>
    !_detectLeadingDecimal(lexeme) ? lexeme : '0$lexeme';

bool _detectTrailingZero(String lexeme) {
  final mantissa = lexeme.split('e').first;

  return mantissa.contains('.') &&
      mantissa.endsWith('0') &&
      mantissa.split('.').last != '0';
}

String _trailingZeroCorrection(String lexeme) {
  if (!_detectTrailingZero(lexeme)) {
    return lexeme;
  } else {
    final mantissa = lexeme.split('e').first;

    return _trailingZeroCorrection(lexeme.replaceFirst(
      mantissa,
      mantissa.substring(0, mantissa.length - 1),
    ));
  }
}
