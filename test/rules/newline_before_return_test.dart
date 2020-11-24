@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/models/source.dart';
import 'package:dart_code_metrics/src/rules/newline_before_return.dart';
import 'package:test/test.dart';

const _content = '''

int simpleFunction() {
  var a = 4;

  if (a > 70) {
    /* multy line
      comment */
    return a + 1;
  } else if (a > 65) {
    a++;
    /* multy line
      comment */
    return a + 1;
  } else if (a > 60) {
    a++;

    /* multy line
      comment */
    return a + 2;
  } else if (a > 55) {
    a--;
    /* multy line
      comment */

    return a + 3;
  }

  if (a > 50) {
    // simple comment
    // simple comment second line
    return a + 1;
  } else if (a > 45) {
    a++;
    // simple comment
    // simple comment second line

    return a + 2;
  } else if (a > 40) {
    a++;
    // simple comment

    // simple comment second line
    return a + 2;
  } else if (a > 35) {
    a--;

    // simple comment
    // simple comment second line
    return a + 3;
  }

  if (a > 30) {
    // simple comment
    return a + 1;
  } else if (a > 25) {
    a++;
    // simple comment
    return a + 2;
  } else if (a > 20) {
    a--;

    // simple comment
    return a + 3;
  }

  if (a > 15) {
    return a + 1;
  } else if (a > 10) {
    a++;
    return a + 2;
  } else if (a > 5) {
    a--;

    return a + 3;
  }

  if (a > 4) return a + 1;

  if (a > 3) return a + 2;

  if (a > 2) {
    return a + 3;
  }

  return a;
}

''';

void main() {
  test('NewlineBeforeReturnRule reports about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
      content: _content,
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    final issues = NewlineBeforeReturnRule()
        .check(Source(sourceUrl, parseResult.content, parseResult.unit));

    expect(issues.length, equals(3));

    expect(
      issues.every((issue) => issue.ruleId == 'newline-before-return'),
      isTrue,
    );
    expect(
      issues.every((issue) => issue.severity == CodeIssueSeverity.style),
      isTrue,
    );
    expect(
      issues.every((issue) => issue.sourceSpan.sourceUrl == sourceUrl),
      isTrue,
    );
    expect(
      issues.map((issue) => issue.sourceSpan.start.offset),
      equals([178, 899, 1061]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.start.line),
      equals([13, 58, 70]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.start.column),
      equals([5, 5, 5]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.end.offset),
      equals([191, 912, 1074]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.text),
      equals(['return a + 1;', 'return a + 2;', 'return a + 2;']),
    );
    expect(
      issues.map((issue) => issue.message),
      equals([
        'Missing blank line before return',
        'Missing blank line before return',
        'Missing blank line before return',
      ]),
    );
    expect(issues.map((issue) => issue.correction), equals([null, null, null]));
    expect(
      issues.map((issue) => issue.correctionComment),
      equals([null, null, null]),
    );
  });
}
