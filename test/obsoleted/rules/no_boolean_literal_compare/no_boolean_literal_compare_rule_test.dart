@TestOn('vm')
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/severity.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/no_boolean_literal_compare_rule.dart';
import 'package:test/test.dart';

const _examplePath =
    'test/obsoleted/rules/no_boolean_literal_compare/examples/example.dart';

void main() {
  test('NoBooleanLiteralCompareRule reports about found issues', () async {
    final path = File(_examplePath).absolute.path;
    final sourceUrl = Uri.parse(path);

    // ignore: deprecated_member_use
    final parseResult = await resolveFile(path: path);

    final issues =
        NoBooleanLiteralCompareRule().check(InternalResolvedUnitResult(
      sourceUrl,
      parseResult!.content!,
      parseResult.unit!,
    ));

    expect(issues, hasLength(11));

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
      equals([74, 96, 118, 140, 159, 180, 292, 334, 406, 446, 570]),
    );
    expect(
      issues.map((issue) => issue.location.start.line),
      equals([6, 8, 10, 12, 14, 16, 22, 24, 27, 28, 37]),
    );
    expect(
      issues.map((issue) => issue.location.start.column),
      equals([11, 11, 11, 11, 7, 7, 11, 11, 25, 25, 34]),
    );
    expect(
      issues.map((issue) => issue.location.end.offset),
      equals([83, 105, 127, 150, 168, 190, 321, 363, 420, 460, 583]),
    );
    expect(
      issues.map((issue) => issue.location.text),
      equals([
        'a == true',
        'b != true',
        'true == c',
        'false != c',
        'e == true',
        'e != false',
        'exampleString.isEmpty == true',
        'true == exampleString.isEmpty',
        'value == false',
        'value != false',
        'value == true',
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
        'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
        'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
        'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
        'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
        'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
      ]),
    );
    expect(
      issues.map((issue) => issue.suggestion!.replacement),
      equals([
        'a',
        '!b',
        'c',
        'c',
        'e',
        'e',
        'exampleString.isEmpty',
        'exampleString.isEmpty',
        '!value',
        'value',
        'value',
      ]),
    );
    expect(
      issues.map((issue) => issue.suggestion!.comment),
      equals([
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
        'This expression is unnecessarily compared to a boolean. Just negate it.',
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
        'This expression is unnecessarily compared to a boolean. Just negate it.',
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
        'This expression is unnecessarily compared to a boolean. Just use it directly.',
      ]),
    );
  });
}
