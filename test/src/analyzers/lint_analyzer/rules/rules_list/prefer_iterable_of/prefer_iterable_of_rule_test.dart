import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_iterable_of/prefer_iterable_of_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _listExamplePath = 'prefer_iterable_of/examples/list_example.dart';
const _setExamplePath = 'prefer_iterable_of/examples/set_example.dart';
const _doubleLinkedQueueExamplePath =
    'prefer_iterable_of/examples/double_linked_queue_example.dart';
const _hashSetExamplePath = 'prefer_iterable_of/examples/hash_set_example.dart';
const _linkedHashSetExamplePath =
    'prefer_iterable_of/examples/linked_hash_set_example.dart';
const _listQueueExamplePath =
    'prefer_iterable_of/examples/list_queue_example.dart';
const _queueExamplePath = 'prefer_iterable_of/examples/queue_example.dart';
const _queueListExamplePath =
    'prefer_iterable_of/examples/queue_list_example.dart';
const _splayTreeSetExamplePath =
    'prefer_iterable_of/examples/splay_tree_set_example.dart';

void main() {
  group('PreferIterableOfRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_listExamplePath);
      final issues = PreferIterableOfRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-iterable-of',
        severity: Severity.warning,
      );
    });

    test('reports about found issues for lists', () async {
      final unit = await RuleTestHelper.resolveFromFile(_listExamplePath);
      final issues = PreferIterableOfRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [4, 5, 9],
        startColumns: [16, 19, 26],
        locationTexts: [
          'List<int>.from(array)',
          'List<num>.from(array)',
          'List.from(array)',
        ],
        messages: [
          'Prefer using .of',
          'Prefer using .of',
          'Prefer using .of',
        ],
        replacements: [
          'List<int>.of(array)',
          'List<num>.of(array)',
          'List.of(array)',
        ],
        replacementComments: [
          "Replace with 'of'.",
          "Replace with 'of'.",
          "Replace with 'of'.",
        ],
      );
    });

    test('reports about found issues for sets', () async {
      final unit = await RuleTestHelper.resolveFromFile(_setExamplePath);
      final issues = PreferIterableOfRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [4, 5, 9],
        startColumns: [16, 18, 25],
        locationTexts: [
          'Set<int>.from(set)',
          'Set<num>.from(set)',
          'Set.from(set)',
        ],
        messages: [
          'Prefer using .of',
          'Prefer using .of',
          'Prefer using .of',
        ],
        replacements: [
          'Set<int>.of(set)',
          'Set<num>.of(set)',
          'Set.of(set)',
        ],
        replacementComments: [
          "Replace with 'of'.",
          "Replace with 'of'.",
          "Replace with 'of'.",
        ],
      );
    });

    test('reports about found issues for double linked queues', () async {
      final unit =
          await RuleTestHelper.resolveFromFile(_doubleLinkedQueueExamplePath);
      final issues = PreferIterableOfRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6, 7, 11],
        startColumns: [16, 20, 27],
        locationTexts: [
          'DoubleLinkedQueue<int>.from(queue)',
          'DoubleLinkedQueue<num>.from(queue)',
          'DoubleLinkedQueue.from(queue)',
        ],
        messages: [
          'Prefer using .of',
          'Prefer using .of',
          'Prefer using .of',
        ],
        replacements: [
          'DoubleLinkedQueue<int>.of(queue)',
          'DoubleLinkedQueue<num>.of(queue)',
          'DoubleLinkedQueue.of(queue)',
        ],
        replacementComments: [
          "Replace with 'of'.",
          "Replace with 'of'.",
          "Replace with 'of'.",
        ],
      );
    });

    test('reports about found issues for hash sets', () async {
      final unit = await RuleTestHelper.resolveFromFile(_hashSetExamplePath);
      final issues = PreferIterableOfRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6, 7, 11],
        startColumns: [16, 18, 25],
        locationTexts: [
          'HashSet<int>.from(hashSet)',
          'HashSet<num>.from(hashSet)',
          'HashSet.from(hashSet)',
        ],
        messages: [
          'Prefer using .of',
          'Prefer using .of',
          'Prefer using .of',
        ],
        replacements: [
          'HashSet<int>.of(hashSet)',
          'HashSet<num>.of(hashSet)',
          'HashSet.of(hashSet)',
        ],
        replacementComments: [
          "Replace with 'of'.",
          "Replace with 'of'.",
          "Replace with 'of'.",
        ],
      );
    });

    test('reports about found issues for linked hash sets', () async {
      final unit =
          await RuleTestHelper.resolveFromFile(_linkedHashSetExamplePath);
      final issues = PreferIterableOfRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6, 7, 11],
        startColumns: [16, 18, 25],
        locationTexts: [
          'LinkedHashSet<int>.from(hashSet)',
          'LinkedHashSet<num>.from(hashSet)',
          'LinkedHashSet.from(hashSet)',
        ],
        messages: [
          'Prefer using .of',
          'Prefer using .of',
          'Prefer using .of',
        ],
        replacements: [
          'LinkedHashSet<int>.of(hashSet)',
          'LinkedHashSet<num>.of(hashSet)',
          'LinkedHashSet.of(hashSet)',
        ],
        replacementComments: [
          "Replace with 'of'.",
          "Replace with 'of'.",
          "Replace with 'of'.",
        ],
      );
    });

    test('reports about found issues for list queues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_listQueueExamplePath);
      final issues = PreferIterableOfRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6, 7, 11],
        startColumns: [16, 20, 27],
        locationTexts: [
          'ListQueue<int>.from(queue)',
          'ListQueue<num>.from(queue)',
          'ListQueue.from(queue)',
        ],
        messages: [
          'Prefer using .of',
          'Prefer using .of',
          'Prefer using .of',
        ],
        replacements: [
          'ListQueue<int>.of(queue)',
          'ListQueue<num>.of(queue)',
          'ListQueue.of(queue)',
        ],
        replacementComments: [
          "Replace with 'of'.",
          "Replace with 'of'.",
          "Replace with 'of'.",
        ],
      );
    });

    test('reports about found issues for queues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_queueExamplePath);
      final issues = PreferIterableOfRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6, 7, 11],
        startColumns: [16, 20, 27],
        locationTexts: [
          'Queue<int>.from(queue)',
          'Queue<num>.from(queue)',
          'Queue.from(queue)',
        ],
        messages: [
          'Prefer using .of',
          'Prefer using .of',
          'Prefer using .of',
        ],
        replacements: [
          'Queue<int>.of(queue)',
          'Queue<num>.of(queue)',
          'Queue.of(queue)',
        ],
        replacementComments: [
          "Replace with 'of'.",
          "Replace with 'of'.",
          "Replace with 'of'.",
        ],
      );
    });

    test('reports about found issues for queue list', () async {
      final unit = await RuleTestHelper.resolveFromFile(_queueListExamplePath);
      final issues = PreferIterableOfRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports about found issues for splay tree sets', () async {
      final unit =
          await RuleTestHelper.resolveFromFile(_splayTreeSetExamplePath);
      final issues = PreferIterableOfRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6, 7, 11],
        startColumns: [16, 18, 25],
        locationTexts: [
          'SplayTreeSet<int>.from(hashSet)',
          'SplayTreeSet<num>.from(hashSet)',
          'SplayTreeSet.from(hashSet)',
        ],
        messages: [
          'Prefer using .of',
          'Prefer using .of',
          'Prefer using .of',
        ],
        replacements: [
          'SplayTreeSet<int>.of(hashSet)',
          'SplayTreeSet<num>.of(hashSet)',
          'SplayTreeSet.of(hashSet)',
        ],
        replacementComments: [
          "Replace with 'of'.",
          "Replace with 'of'.",
          "Replace with 'of'.",
        ],
      );
    });
  });
}
