import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../models/issue.dart';
import '../../models/replacement.dart';
import '../../models/rule_documentation.dart';
import '../../models/severity.dart';
import '../../obsoleted/models/internal_resolved_unit_result.dart';
import '../../utils/node_utils.dart';
import '../../utils/rule_utils.dart';
import '../rule.dart';

part 'double_literal_visitor.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/number-literal-format/)

const _documentation = RuleDocumentation(
  name: 'Double Literal Format',
  brief:
      "Checks that double literals should begin with '0.' instead of just '.', and should not end with a trailing '0'",
);

const _failureLeadingZero =
    "Double literal shouldn't have redundant leading '0'.";
const _correctionCommentLeadingZero = "Remove redundant leading '0'";

const _failureLeadingDecimal = "Double literal shouldn't begin with '.'.";
const _correctionCommentLeadingDecimal = "Add missing leading '0'";

const _failureTrailingZero = "Double literal shouldn't have a trailing '0'.";
const _correctionCommentTrailingZero = "Remove redundant trailing '0'";

class DoubleLiteralFormatRule extends Rule {
  static const String ruleId = 'double-literal-format';

  DoubleLiteralFormatRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentation: _documentation,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit.visitChildren(_visitor);

    final issues = <Issue>[];

    for (final literal in _visitor.literals) {
      final lexeme = literal.literal.lexeme;

      String? message;
      Replacement? replacement;

      if (_detectLeadingZero(lexeme)) {
        message = _failureLeadingZero;

        replacement = Replacement(
          comment: _correctionCommentLeadingZero,
          replacement: _leadingZeroCorrection(lexeme),
        );
      } else if (_detectLeadingDecimal(lexeme)) {
        message = _failureLeadingDecimal;

        replacement = Replacement(
          comment: _correctionCommentLeadingDecimal,
          replacement: _leadingDecimalCorrection(lexeme),
        );
      } else if (_detectTrailingZero(lexeme)) {
        message = _failureTrailingZero;

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
