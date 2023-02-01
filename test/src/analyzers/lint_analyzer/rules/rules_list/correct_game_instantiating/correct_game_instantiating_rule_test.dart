import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/correct_game_instantiating/correct_game_instantiating_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'correct_game_instantiating/examples/example.dart';

void main() {
  group('CorrectGameInstantiatingRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = CorrectGameInstantiatingRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'correct-game-instantiating',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = CorrectGameInstantiatingRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [4, 25],
        startColumns: [12, 12],
        locationTexts: [
          'GameWidget(game: MyFlameGame())',
          'GameWidget(game: MyFlameGame())',
        ],
        messages: [
          'Incorrect game instantiation. The game will reset on each rebuild.',
          'Incorrect game instantiation. The game will reset on each rebuild.',
        ],
        replacements: [
          'GameWidget.controlled(gameFactory: MyFlameGame.new,);',
          null,
        ],
        replacementComments: [
          "Replace with 'controlled'.",
          null,
        ],
      );
    });
  });
}
