@TestOn('vm')

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/potential_null_dereference.dart';
import 'package:test/test.dart';

// ignore_for_file: no_adjacent_strings_in_list

const _content = '''

class Test {
  final String value;
  final Test child;

  const Test(this.value, this.child);

  String getValue() {
    return value;
  }
}

function doWork(Test object) {
  if (object == null) {
    final text = object.value;
    object.getValue();
  }

  if (object.child == null) {
    final text = object.child.value;
    object.child.getValue();
  }

  Test mutable;
  if (mutable == null) {
    final text = mutable.value;
    mutable = Test('val', null);
    mutable.getValue();
  }

  if (object == null && object.value == 'test') {

  }

  if (object == null && 'test' == object.value) {

  }

  if (null == object && object.getValue())  {

  }

  if (object == null && ('test' == object.value || object.value == 'test')) {

  }

  if (object != null || object.value == 'test') {

  }

  if (object.child == null && object.child.value == 'test') {

  }

  if (object.child != null || object.child.value == 'test') {

  }

  if (object.child == null && object.child.getValue()) {

  }
}

''';

const _correctContent = '''

class Test {
  final String value;
  final Test child;

  const Test(this.value, this.child);

  String getValue() {
    return value;
  }
}

function doWork(Test object) {
  if (object != null) {
    final text = object.value;
    object.getValue();
  }

  if (object.child != null) {
    final text = object.child.value;
    object.child.getValue();
  }

  Test mutable;
  if (mutable != null) {
    final text = mutable.value;
    mutable = Test('val', null);
    mutable.getValue();
  }

  if (mutable == null) {
    mutable = Test('val', null);
    final text = mutable.value;
    mutable.getValue();
  }

  if (object == null || object.value == 'test') {

  }

  if (object == null || 'test' == object.value) {

  }

  if (null == object || object.getValue())  {

  }

  if (object == null || ('test' == object.value || object.value == 'test')) {

  }

  if (object != null && object.value == 'test') {

  }

  if (object.child == null || object.child.value == 'test') {

  }

  if (object.child != null && object.child.value == 'test') {

  }

  if (object.child == null || object.child.getValue()) {

  }

  if (object == null) {
    final object = Test();
    final value = object.value;
  }

  if (object == null) {
    final list = [1, 2, 3];
    list.map((object) => object);
  }
}

''';

void main() {
  group('PotentialNullDereference', () {
    test('initialization', () {
      final sourceUrl = Uri.parse('/example.dart');

      final parseResult = parseString(
          content: _content,
          featureSet: FeatureSet.fromEnableFlags([]),
          throwIfDiagnostics: false);

      final issues = PotentialNullDereference()
          .check(parseResult.unit, sourceUrl, parseResult.content);

      expect(
        issues.every((issue) => issue.ruleId == 'potential-null-dereference'),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.severity == CodeIssueSeverity.warning),
        isTrue,
      );
    });

    test('reports about found issues', () {
      final sourceUrl = Uri.parse('/example.dart');

      final parseResult = parseString(
          content: _content,
          featureSet: FeatureSet.fromEnableFlags([]),
          throwIfDiagnostics: false);

      final issues = PotentialNullDereference()
          .check(parseResult.unit, sourceUrl, parseResult.content);

      expect(
        issues.map((issue) => issue.sourceSpan.start.offset),
        equals(
            [215, 233, 304, 328, 416, 499, 555, 611, 663, 747, 803, 871, 939]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.start.line),
        equals([15, 16, 20, 21, 26, 31, 35, 39, 43, 47, 51, 55, 59]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.start.column),
        equals([18, 5, 18, 5, 18, 7, 7, 7, 7, 7, 7, 7, 7]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.end.offset),
        equals(
            [221, 239, 316, 340, 423, 539, 595, 646, 731, 787, 855, 923, 986]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.text),
        equals([
          'object',
          'object',
          'object.child',
          'object.child',
          'mutable',
          "object == null && object.value == 'test'",
          "object == null && 'test' == object.value",
          'null == object && object.getValue()',
          "object == null && ('test' == object.value || object.value == 'test')",
          "object != null || object.value == 'test'",
          "object.child == null && object.child.value == 'test'",
          "object.child != null || object.child.value == 'test'",
          'object.child == null && object.child.getValue()',
        ]),
      );
      expect(
        issues.map((issue) => issue.message),
        equals([
          'object can potentially be null',
          'object can potentially be null',
          'object.child can potentially be null',
          'object.child can potentially be null',
          'mutable can potentially be null',
          'object can potentially be null',
          'object can potentially be null',
          'object can potentially be null',
          'object can potentially be null',
          'object can potentially be null',
          'object.child can potentially be null',
          'object.child can potentially be null',
          'object.child can potentially be null',
        ]),
      );
    });

    test('reports about no found issues', () {
      final sourceUrl = Uri.parse('/example.dart');

      final parseResult = parseString(
          content: _correctContent,
          featureSet: FeatureSet.fromEnableFlags([]),
          throwIfDiagnostics: false);

      final issues = PotentialNullDereference()
          .check(parseResult.unit, sourceUrl, parseResult.content);

      expect(issues.isEmpty, isTrue);
    });
  });
}
