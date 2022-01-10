import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/binary_expression_operand_order/binary_expression_operand_order_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'binary_expression_operand_order/examples/example.dart';

void main() {
  group('BinaryExpressionOperandOrderRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = BinaryExpressionOperandOrderRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'binary-expression-operand-order',
        severity: Severity.style,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = BinaryExpressionOperandOrderRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [3, 4, 5, 6, 7, 8],
        startColumns: [14, 19, 19, 14, 14, 14],
        locationTexts: [
          '1 + c',
          '1 + c',
          '12.44 * c',
          '1 & c',
          '2 | c',
          '4 ^ c',
        ],
        replacements: [
          'c + 1',
          'c + 1',
          'c * 12.44',
          'c & 1',
          'c | 2',
          'c ^ 4',
        ],
      );
    });
  });
}
