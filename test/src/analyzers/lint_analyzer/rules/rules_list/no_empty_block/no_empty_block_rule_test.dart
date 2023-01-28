import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/no_empty_block/no_empty_block_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'no_empty_block/examples/example.dart';

void main() {
  group('NoEmptyBlockRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = NoEmptyBlockRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'no-empty-block',
        severity: Severity.style,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = NoEmptyBlockRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2, 7, 15, 25],
        startColumns: [7, 15, 30, 22],
        locationTexts: [
          '{}',
          '{\n  }',
          '{}',
          '{}',
        ],
        messages: [
          'Block is empty. Empty blocks are often indicators of missing code.',
          'Block is empty. Empty blocks are often indicators of missing code.',
          'Block is empty. Empty blocks are often indicators of missing code.',
          'Block is empty. Empty blocks are often indicators of missing code.',
        ],
      );
    });
  });
}
