@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/potential_null_dereference.dart';
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

Test doWork(Test object) {
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
  String mutableValue;

  Test(this.value, this.child);

  String getValue() {
    return value;
  }
}

Test doWork(Test object) {
  if (object == null) {
    return object;
  }

  if (object != null) {
    final text = object.value;
    object.getValue();
  }

  if (object.child != null) {
    final text = object.child.value;
    object.child.getValue();
  }

  String mutableValue;
  if (mutableValue == null) {
    object.mutableValue = mutableValue;
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
        // ignore: deprecated_member_use
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false,
      );

      final issues =
          PotentialNullDereference().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.every((issue) => issue.ruleId == 'potential-null-dereference'),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.severity == Severity.warning),
        isTrue,
      );
    });

    test('reports about found issues', () {
      final sourceUrl = Uri.parse('/example.dart');

      final parseResult = parseString(
        content: _content,
        // ignore: deprecated_member_use
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false,
      );

      final issues =
          PotentialNullDereference().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.map((issue) => issue.location.start.offset),
        equals(
          [211, 229, 300, 324, 412, 495, 551, 607, 659, 743, 799, 867, 935],
        ),
      );
      expect(
        issues.map((issue) => issue.location.start.line),
        equals([15, 16, 20, 21, 26, 31, 35, 39, 43, 47, 51, 55, 59]),
      );
      expect(
        issues.map((issue) => issue.location.start.column),
        equals([18, 5, 18, 5, 18, 7, 7, 7, 7, 7, 7, 7, 7]),
      );
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals(
          [217, 235, 312, 336, 419, 535, 591, 642, 727, 783, 851, 919, 982],
        ),
      );
      expect(
        issues.map((issue) => issue.location.text),
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
        // ignore: deprecated_member_use
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false,
      );

      final issues =
          PotentialNullDereference().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(issues.isEmpty, isTrue);
    });
  });
}
