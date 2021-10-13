import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_correct_type_name/prefer_correct_type_name.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _path = 'prefer_correct_type_name/examples';
const _classExample = '$_path/class_example.dart';
const _enumExample = '$_path/enum_example.dart';
const _mixinExample = '$_path/mixin_example.dart';
const _extensionExample = '$_path/extension_example.dart';

void main() {
  group('PreferCorrectTypeName', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExample);
      final issues = PreferCorrectTypeName().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-correct-type-name',
        severity: Severity.style,
      );
    });

    test('reports about found all issues in class_example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExample);
      final issues = PreferCorrectTypeName({
        'max-length': 15,
        'min-length': 3,
        'excluded': ['_exampleExclude'],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [52, 124, 196, 250, 310, 397],
        startLines: [2, 7, 12, 17, 22, 27],
        startColumns: [7, 7, 7, 7, 7, 7],
        endOffsets: [59, 132, 199, 252, 330, 416],
        locationTexts: [
          'example',
          '_example',
          '_ex',
          'ex',
          '_ExampleWithLongName',
          'ExampleWithLongName',
        ],
        messages: [
          "The 'example' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The '_example' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The '_ex' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The 'ex' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The '_ExampleWithLongName' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The 'ExampleWithLongName' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
        ],
      );
    });

    test('reports about found all issues in enum_example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_enumExample);
      final issues = PreferCorrectTypeName({
        'max-length': 15,
        'min-length': 3,
        'excluded': ['_exampleExclude'],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [50, 127, 203, 266, 335, 414],
        startLines: [2, 8, 14, 20, 26, 32],
        startColumns: [6, 6, 6, 6, 6, 6],
        endOffsets: [57, 135, 206, 268, 355, 433],
        locationTexts: [
          'example',
          '_example',
          '_ex',
          'ex',
          '_ExampleWithLongName',
          'ExampleWithLongName',
        ],
        messages: [
          "The 'example' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The '_example' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The '_ex' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The 'ex' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The '_ExampleWithLongName' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The 'ExampleWithLongName' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
        ],
      );
    });

    test('reports about found all issues in extension_example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_extensionExample);
      final issues = PreferCorrectTypeName({
        'max-length': 15,
        'min-length': 3,
        'excluded': ['_exampleExclude'],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [56, 132, 207, 269, 337, 415],
        startLines: [2, 5, 8, 11, 14, 17],
        startColumns: [11, 11, 11, 11, 11, 11],
        endOffsets: [63, 140, 210, 271, 357, 434],
        locationTexts: [
          'example',
          '_example',
          '_ex',
          'ex',
          '_ExampleWithLongName',
          'ExampleWithLongName',
        ],
        messages: [
          "The 'example' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The '_example' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The '_ex' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The 'ex' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The '_ExampleWithLongName' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The 'ExampleWithLongName' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
        ],
      );
    });

    test('reports about found all issues in mixin_example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_mixinExample);
      final issues = PreferCorrectTypeName({
        'max-length': 15,
        'min-length': 3,
        'excluded': ['_exampleExclude'],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [52, 110, 167, 211, 261, 321],
        startLines: [2, 5, 8, 11, 14, 17],
        startColumns: [7, 7, 7, 7, 7, 7],
        endOffsets: [59, 118, 170, 213, 281, 340],
        locationTexts: [
          'example',
          '_example',
          '_ex',
          'ex',
          '_ExampleWithLongName',
          'ExampleWithLongName',
        ],
        messages: [
          "The 'example' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The '_example' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The '_ex' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The 'ex' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The '_ExampleWithLongName' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
          "The 'ExampleWithLongName' name should only contain alphanumeric characters, start with an uppercase character and span between 3 and 15 characters in length",
        ],
      );
    });
  });
}
