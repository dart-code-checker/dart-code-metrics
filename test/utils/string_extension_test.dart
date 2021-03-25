@TestOn('vm')
import 'package:code_checker/src/utils/string_extension.dart';
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
  });
}
