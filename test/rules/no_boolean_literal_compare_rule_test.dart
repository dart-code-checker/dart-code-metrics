@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/no_boolean_literal_compare_rule.dart';
import 'package:test/test.dart';

const _content = '''

void main() {
  var a = true;

  var b = a == true;

  var c = b != true;

  var d = true == c;

  var e = false != c;

  if (e == true) {}

  if (e != false) {}

  [true, false]
      .where((value) => value == false)
      .where((value) => value != false);

  var y = a != e;
  var z = a == e;

  if (b == d) {}

  if (b != d) {}

  [true, false].where((value) => value == true).where((value) => value == c);
}

''';

void main() {
  test('NoBooleanLiteralCompareRule reports about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
        content: _content,
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false);

    final issues =
        const NoBooleanLiteralCompareRule().check(parseResult.unit, sourceUrl);

    expect(issues.length, equals(9));

    expect(issues.map((issue) => issue.ruleId).toSet().single,
        equals('no-boolean-literal-compare'));
    expect(issues.map((issue) => issue.severity).toSet().single,
        equals(CodeIssueSeverity.style));
    expect(issues.map((issue) => issue.sourceSpan.sourceUrl).toSet().single,
        equals(sourceUrl));
    expect(issues.map((issue) => issue.sourceSpan.start.offset),
        equals([42, 64, 86, 108, 127, 148, 204, 244, 368]));
    expect(issues.map((issue) => issue.sourceSpan.start.line),
        equals([5, 7, 9, 11, 13, 15, 18, 19, 28]));
    expect(issues.map((issue) => issue.sourceSpan.start.column),
        equals([11, 11, 11, 11, 7, 7, 25, 25, 34]));
    expect(issues.map((issue) => issue.sourceSpan.end.offset),
        equals([51, 73, 95, 118, 136, 158, 218, 258, 381]));
    expect(
        issues.map((issue) => issue.sourceSpan.text),
        equals([
          'a == true',
          'b != true',
          'true == c',
          'false != c',
          'e == true',
          'e != false',
          'value == false',
          'value != false',
          'value == true',
        ]));
    expect(
        issues.map((issue) => issue.message),
        equals([
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
        ]));
    expect(issues.map((issue) => issue.correction),
        equals(['a', '!b', 'c', 'c', 'e', 'e', '!value', 'value', 'value']));
    expect(
        issues.map((issue) => issue.correctionComment),
        equals([
          'This expression is unnecessarily compared to a boolean. Just use it directly.',
          'This expression is unnecessarily compared to a boolean. Just negate it.',
          'This expression is unnecessarily compared to a boolean. Just use it directly.',
          'This expression is unnecessarily compared to a boolean. Just use it directly.',
          'This expression is unnecessarily compared to a boolean. Just use it directly.',
          'This expression is unnecessarily compared to a boolean. Just use it directly.',
          'This expression is unnecessarily compared to a boolean. Just negate it.',
          'This expression is unnecessarily compared to a boolean. Just use it directly.',
          'This expression is unnecessarily compared to a boolean. Just use it directly.',
        ]));
  });
}
