import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_correct_type_name/prefer_correct_type_name_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _path = 'prefer_correct_type_name/examples';
const _classExample = '$_path/class_example.dart';
const _enumExample = '$_path/enum_example.dart';
const _extensionExample = '$_path/extension_example.dart';
const _mixinExample = '$_path/mixin_example.dart';

void main() {
  group('PreferCorrectTypeNameRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExample);
      final issues = PreferCorrectTypeNameRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-correct-type-name',
        severity: Severity.style,
      );
    });

    test('reports about all found issues in class_example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExample);

      final issues = PreferCorrectTypeNameRule({
        'max-length': 15,
        'min-length': 3,
        'excluded': ['_exampleExclude'],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2, 7, 12, 17, 22, 27],
        startColumns: [7, 7, 7, 7, 7, 7],
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

    test('reports about all found issues in enum_example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_enumExample);

      final issues = PreferCorrectTypeNameRule({
        'max-length': 15,
        'min-length': 3,
        'excluded': ['_exampleExclude'],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2, 8, 14, 20, 26, 32],
        startColumns: [6, 6, 6, 6, 6, 6],
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

    test('reports about all found issues in extension_example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_extensionExample);

      final issues = PreferCorrectTypeNameRule({
        'max-length': 15,
        'min-length': 3,
        'excluded': ['_exampleExclude'],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2, 5, 8, 11, 14, 17],
        startColumns: [11, 11, 11, 11, 11, 11],
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

    test('reports about all found issues in mixin_example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_mixinExample);

      final issues = PreferCorrectTypeNameRule({
        'max-length': 15,
        'min-length': 3,
        'excluded': ['_exampleExclude'],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2, 5, 8, 11, 14, 17],
        startColumns: [7, 7, 7, 7, 7, 7],
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

    test('works with invalid files', () async {
      final rule = PreferCorrectTypeNameRule();

      final classExampleUnit = await RuleTestHelper.createAndResolveFromFile(
        content: 'class ',
        filePath: '$_path/invalid_class_example.dart',
      );
      expect(rule.check(classExampleUnit), isEmpty);

      final classEnumUnit = await RuleTestHelper.createAndResolveFromFile(
        content: 'enum ',
        filePath: '$_path/invalid_enum_example.dart',
      );
      expect(rule.check(classEnumUnit), isEmpty);

      final classExtensionUnit = await RuleTestHelper.createAndResolveFromFile(
        content: 'extension ',
        filePath: '$_path/invalid_extension_example.dart',
      );
      expect(rule.check(classExtensionUnit), isEmpty);

      final classMixinUnit = await RuleTestHelper.createAndResolveFromFile(
        content: 'mixin ',
        filePath: '$_path/invalid_mixin_example.dart',
      );
      expect(rule.check(classMixinUnit), isEmpty);
    });
  });
}
