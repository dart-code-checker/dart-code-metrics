@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/no_boolean_literal_compare_rule.dart';
import 'package:test/test.dart';

const _content = '''

void main() {
  const exampleString = 'text';

  var a = true;

  var b = a== true;

  var c = b !=true;

  var d = true==c;

  var e = false != c;

  if (e== true) {}

  if (e !=false) {}

  var f = exampleString?.isEmpty==true;

  var g = true == exampleString?.isEmpty;

  var h = exampleString.isEmpty == true;

  var i = true == exampleString.isEmpty;

  [true, false]
      .where((value) => value== false)
      .where((value) => value !=false);

  var y = a!=e;
  var z = a == e;

  if (b== d) {}

  if (b !=d) {}

  [true, false].where((value) => value==true).where((value) => value == c);
}

''';

void main() {
  test('NoBooleanLiteralCompareRule reports about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
      content: _content,
      // ignore: deprecated_member_use
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    final issues =
        NoBooleanLiteralCompareRule().check(InternalResolvedUnitResult(
      sourceUrl,
      parseResult.content,
      parseResult.unit,
    ));

    expect(issues, hasLength(13));

    expect(
      issues.every((issue) => issue.ruleId == 'no-boolean-literal-compare'),
      isTrue,
    );
    expect(
      issues.every((issue) => issue.severity == Severity.style),
      isTrue,
    );
    expect(
      issues.every((issue) => issue.location.sourceUrl == sourceUrl),
      isTrue,
    );
    expect(
      issues.map((issue) => issue.location.start.offset),
      equals([75, 96, 117, 137, 156, 176, 201, 242, 285, 327, 399, 438, 557]),
    );
    expect(
      issues.map((issue) => issue.location.start.line),
      equals([7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 28, 29, 38]),
    );
    expect(
      issues.map((issue) => issue.location.start.column),
      equals([11, 11, 11, 11, 7, 7, 11, 11, 11, 11, 25, 25, 34]),
    );
    expect(
      issues.map((issue) => issue.location.end.offset),
      equals([83, 104, 124, 147, 164, 185, 229, 272, 314, 356, 412, 451, 568]),
    );
    expect(
      issues.map((issue) => issue.location.text),
      equals([
        'a== true',
        'b !=true',
        'true==c',
        'false != c',
        'e== true',
        'e !=false',
        'exampleString?.isEmpty==true',
        'true == exampleString?.isEmpty',
        'exampleString.isEmpty == true',
        'true == exampleString.isEmpty',
        'value== false',
        'value !=false',
        'value==true',
      ]),
    );
    expect(
      issues.map((issue) => issue.message),
      equals([
        'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
        'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
        'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
        'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
        'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
        'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
        'Comparison of null-conditional boolean with boolean literal may result in comparing null with boolean.',
        'Comparison of null-conditional boolean with boolean literal may result in comparing null with boolean.',
        'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
        'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
        'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
        'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
        'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
      ]),
    );
    expect(
      issues.map((issue) => issue.suggestion.replacement),
      equals([
        'a',
        '!b',
        'c',
        'c',
        'e',
        'e',
        'exampleString?.isEmpty ?? false',
        'exampleString?.isEmpty ?? false',
        'exampleString.isEmpty',
        'exampleString.isEmpty',
        '!value',
        'value',
        'value',
      ]),
    );
    expect(
      issues.map((issue) => issue.suggestion.comment),
      equals([
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
        'This expression is unnecessarily compared to a boolean. Just negate it.',
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
        'Prefer using null-coalescing operator with false literal on right hand side.',
        'Prefer using null-coalescing operator with false literal on right hand side.',
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
        'This expression is unnecessarily compared to a boolean. Just negate it.',
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
      ]),
    );
  });
}
