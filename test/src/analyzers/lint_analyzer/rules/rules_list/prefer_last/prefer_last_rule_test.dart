import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_last/prefer_last_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _doubleLinkedQueueExamplePath =
    'prefer_last/examples/double_linked_queue_example.dart';
const _hashSetExamplePath = 'prefer_last/examples/hash_set_example.dart';
const _iterableExamplePath = 'prefer_last/examples/iterable_example.dart';
const _linkedHashSetExamplePath =
    'prefer_last/examples/linked_hash_set_example.dart';
const _listExamplePath = 'prefer_last/examples/list_example.dart';
const _listQueueExamplePath = 'prefer_last/examples/list_queue_example.dart';
const _queueExamplePath = 'prefer_last/examples/queue_example.dart';
const _setExamplePath = 'prefer_last/examples/set_example.dart';
const _splayTreeSetExamplePath =
    'prefer_last/examples/splay_tree_set_example.dart';
const _unmodifiableListViewExamplePath =
    'prefer_last/examples/unmodifiable_list_view_example.dart';
const _unmodifiableSetViewExamplePath =
    'prefer_last/examples/unmodifiable_set_view_example.dart';

void main() {
  group('PreferLastRule', () {
    test('initialization', () async {
      final unit =
          await RuleTestHelper.resolveFromFile(_doubleLinkedQueueExamplePath);
      final issues = PreferLastRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-last',
        severity: Severity.style,
      );
    });

    test('reports about found issues for double linked queue', () async {
      final unit =
          await RuleTestHelper.resolveFromFile(_doubleLinkedQueueExamplePath);
      final issues = PreferLastRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [11, 18],
        startColumns: [3, 5],
        locationTexts: [
          'doubleLinkedQueue.elementAt(doubleLinkedQueue.length - 1)',
          '..elementAt(doubleLinkedQueue.length - 1)',
        ],
        messages: [
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
        ],
        replacements: [
          'doubleLinkedQueue.last',
          '..last',
        ],
        replacementComments: [
          "Replace with 'last'.",
          "Replace with 'last'.",
        ],
      );
    });

    test('reports about found issues for hash set', () async {
      final unit = await RuleTestHelper.resolveFromFile(_hashSetExamplePath);
      final issues = PreferLastRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [11, 18],
        startColumns: [3, 5],
        locationTexts: [
          'hashSet.elementAt(hashSet.length - 1)',
          '..elementAt(hashSet.length - 1)',
        ],
        messages: [
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
        ],
        replacements: [
          'hashSet.last',
          '..last',
        ],
        replacementComments: [
          "Replace with 'last'.",
          "Replace with 'last'.",
        ],
      );
    });

    test('reports about found issues for iterable', () async {
      final unit = await RuleTestHelper.resolveFromFile(_iterableExamplePath);
      final issues = PreferLastRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [11, 18],
        startColumns: [3, 5],
        locationTexts: [
          'iterable.elementAt(iterable.length - 1)',
          '..elementAt(iterable.length - 1)',
        ],
        messages: [
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
        ],
        replacements: [
          'iterable.last',
          '..last',
        ],
        replacementComments: [
          "Replace with 'last'.",
          "Replace with 'last'.",
        ],
      );
    });

    test('reports about found issues for linked hash set', () async {
      final unit =
          await RuleTestHelper.resolveFromFile(_linkedHashSetExamplePath);
      final issues = PreferLastRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [11, 18],
        startColumns: [3, 5],
        locationTexts: [
          'linkedHashSet.elementAt(linkedHashSet.length - 1)',
          '..elementAt(linkedHashSet.length - 1)',
        ],
        messages: [
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
        ],
        replacements: [
          'linkedHashSet.last',
          '..last',
        ],
        replacementComments: [
          "Replace with 'last'.",
          "Replace with 'last'.",
        ],
      );
    });

    test('reports about found issues for list', () async {
      final unit = await RuleTestHelper.resolveFromFile(_listExamplePath);
      final issues = PreferLastRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [9, 14, 18, 23, 28, 33],
        startColumns: [3, 3, 5, 5, 9, 5],
        locationTexts: [
          'list.elementAt(list.length - 1)',
          'list[list.length - 1]',
          '..elementAt(list.length - 1)',
          '..[list.length - 1]',
          '..[list.length - 1]',
          '..[list.length - 1]',
        ],
        messages: [
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
        ],
        replacements: [
          'list.last',
          'list.last',
          '..last',
          '..last',
          '..last',
          '..last',
        ],
        replacementComments: [
          "Replace with 'last'.",
          "Replace with 'last'.",
          "Replace with 'last'.",
          "Replace with 'last'.",
          "Replace with 'last'.",
          "Replace with 'last'.",
        ],
      );
    });

    test('reports about found issues for list queue', () async {
      final unit = await RuleTestHelper.resolveFromFile(_listQueueExamplePath);
      final issues = PreferLastRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [11, 18],
        startColumns: [3, 5],
        locationTexts: [
          'listQueue.elementAt(listQueue.length - 1)',
          '..elementAt(listQueue.length - 1)',
        ],
        messages: [
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
        ],
        replacements: [
          'listQueue.last',
          '..last',
        ],
        replacementComments: [
          "Replace with 'last'.",
          "Replace with 'last'.",
        ],
      );
    });

    test('reports about found issues for queue', () async {
      final unit = await RuleTestHelper.resolveFromFile(_queueExamplePath);
      final issues = PreferLastRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [11, 18],
        startColumns: [3, 5],
        locationTexts: [
          'queue.elementAt(queue.length - 1)',
          '..elementAt(queue.length - 1)',
        ],
        messages: [
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
        ],
        replacements: [
          'queue.last',
          '..last',
        ],
        replacementComments: [
          "Replace with 'last'.",
          "Replace with 'last'.",
        ],
      );
    });

    test('reports about found issues for set', () async {
      final unit = await RuleTestHelper.resolveFromFile(_setExamplePath);
      final issues = PreferLastRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [9, 16],
        startColumns: [3, 5],
        locationTexts: [
          'set.elementAt(set.length - 1)',
          '..elementAt(set.length - 1)',
        ],
        messages: [
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
        ],
        replacements: [
          'set.last',
          '..last',
        ],
        replacementComments: [
          "Replace with 'last'.",
          "Replace with 'last'.",
        ],
      );
    });

    test('reports about found issues for splay tree set', () async {
      final unit =
          await RuleTestHelper.resolveFromFile(_splayTreeSetExamplePath);
      final issues = PreferLastRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [11, 18],
        startColumns: [3, 5],
        locationTexts: [
          'splayTreeSet.elementAt(splayTreeSet.length - 1)',
          '..elementAt(splayTreeSet.length - 1)',
        ],
        messages: [
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
        ],
        replacements: [
          'splayTreeSet.last',
          '..last',
        ],
        replacementComments: [
          "Replace with 'last'.",
          "Replace with 'last'.",
        ],
      );
    });

    test('reports about found issues for unmodifiable list view', () async {
      final unit = await RuleTestHelper.resolveFromFile(
        _unmodifiableListViewExamplePath,
      );
      final issues = PreferLastRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [11, 16, 20, 25, 30, 35],
        startColumns: [3, 3, 5, 5, 9, 5],
        locationTexts: [
          'unmodifiableListView.elementAt(unmodifiableListView.length - 1)',
          'unmodifiableListView[unmodifiableListView.length - 1]',
          '..elementAt(unmodifiableListView.length - 1)',
          '..[unmodifiableListView.length - 1]',
          '..[unmodifiableListView.length - 1]',
          '..[unmodifiableListView.length - 1]',
        ],
        messages: [
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
        ],
        replacements: [
          'unmodifiableListView.last',
          'unmodifiableListView.last',
          '..last',
          '..last',
          '..last',
          '..last',
        ],
        replacementComments: [
          "Replace with 'last'.",
          "Replace with 'last'.",
          "Replace with 'last'.",
          "Replace with 'last'.",
          "Replace with 'last'.",
          "Replace with 'last'.",
        ],
      );
    });

    test('reports about found issues for unmodifiable set view', () async {
      final unit =
          await RuleTestHelper.resolveFromFile(_unmodifiableSetViewExamplePath);
      final issues = PreferLastRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [11, 18],
        startColumns: [3, 5],
        locationTexts: [
          'unmodifiableSetView.elementAt(unmodifiableSetView.length - 1)',
          '..elementAt(unmodifiableSetView.length - 1)',
        ],
        messages: [
          'Use last instead of accessing the last element by index.',
          'Use last instead of accessing the last element by index.',
        ],
        replacements: [
          'unmodifiableSetView.last',
          '..last',
        ],
        replacementComments: [
          "Replace with 'last'.",
          "Replace with 'last'.",
        ],
      );
    });
  });
}
