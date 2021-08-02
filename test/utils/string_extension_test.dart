@TestOn('vm')
import 'package:dart_code_metrics/src/utils/string_extension.dart';
import 'package:test/test.dart';

void main() {
  group('StringExtensions', () {
    test('camelCaseToText converts camelCase string to text', () {
      expect('camelCaseString'.camelCaseToText(), equals('camel case string'));
      expect('CamelCaseString'.camelCaseToText(), equals('camel case string'));
    });

    test('capitalize makes first letter in upper case', () {
      expect('simple text'.capitalize(), equals('Simple text'));
      expect('Simple text'.capitalize(), equals('Simple text'));
    });

    test('snakeCaseToKebab converts snake_case to kebab-case', () {
      expect('snake_case'.snakeCaseToKebab(), equals('snake-case'));
      expect(
        'snake_case_string'.snakeCaseToKebab(),
        equals('snake-case-string'),
      );
    });

    test('snakeCaseToKebab doesn`t change a kebab-case string', () {
      expect('kebab-case'.snakeCaseToKebab(), equals('kebab-case'));
    });

    test('camelCaseToSnakeCase change a camel case string', () {
      expect('CamelCase'.camelCaseToSnakeCase(), equals('camel_case'));
      expect('_CamelCase'.camelCaseToSnakeCase(), equals('__camel_case'));
      expect('_CamelCase_'.camelCaseToSnakeCase(), equals('__camel_case_'));
      expect('_Camel Case'.camelCaseToSnakeCase(), equals('__camel_case'));
      expect(
        '_CamelCaseLongTest_'.camelCaseToSnakeCase(),
        equals('__camel_case_long_test_'),
      );
      expect(
        '_CamelCaseLongTest_'.camelCaseToSnakeCase(),
        equals('__camel_case_long_test_'),
      );
    });

    test('camelCaseToSnakeCase doesn`t change a kebab-case string', () {
      expect('kebab-case'.camelCaseToSnakeCase(), equals('kebab-case'));
    });
  });
}
