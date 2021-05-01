@TestOn('vm')
import 'package:dart_code_metrics/src/models/severity.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/no_empty_block.dart';
import 'package:test/test.dart';

import '../../../helpers/file_resolver.dart';
import '../../../helpers/rule_test_helper.dart';

const _examplePath =
    'test/obsoleted/rules/no_empty_block/examples/example.dart';

void main() {
  group('NoEmptyBlockRule', () {
    test('initialization', () async {
      final unit = await FileResolver.resolve(_examplePath);
      final issues = NoEmptyBlockRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'no-empty-block',
        severity: Severity.style,
      );
    });

    test('reports about found issues', () async {
      final unit = await FileResolver.resolve(_examplePath);
      final issues = NoEmptyBlockRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [29, 92, 240, 375],
        startLines: [2, 7, 16, 26],
        startColumns: [7, 15, 30, 22],
        endOffsets: [31, 97, 242, 377],
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
