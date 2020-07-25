@TestOn('vm')

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/prefer_conditional_expressions.dart';
import 'package:test/test.dart';

// ignore_for_file: no_adjacent_strings_in_list

const _content = '''

int a = 1;

int testFunction() {
  if (a == 1) {
    a = 2;
  } else if (a == 2) {
    a = 3;
  }

  if (a == 3) {
    a = 2;
  } else {
    a = 3;
  }

  if (a == 4) {
    a = 2;
  } else {
    return 3;
  }

  if (a == 5) {
    return a;
  } else {
    a = 3;
  }

  if (a == 6) {
    return a;
  } else {
    return 3;
  }

  if (a == 7) {
    return 2;
  }

  if (a == 8) {
    a = 3;
  }

  if (a == 9) a = 2;
  else a = 3;

  if (a == 10) return a;
  else a = 3;

  if (a == 11) a = 2;
  else return a;

  if (a == 12) return 2;
  else return a;

  if (a == 13) return a;

  if (a == 14) a = 3;
}

int anotherTestFunction() {
  if (a == 2) {
    final b = a;

    return a;
  } else {
    return a;
  }

  if (a == 3) {
    final b = a;

    return 2;
  } else return 6;
}

''';

void main() {
  test('PreferConditionalExpressions reports about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
        content: _content,
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false);

    final issues = const PreferConditionalExpressions()
        .check(parseResult.unit, sourceUrl, parseResult.content);

    expect(
      issues.every((issue) => issue.ruleId == 'prefer-conditional-expressions'),
      isTrue,
    );
    expect(
      issues.every((issue) => issue.severity == CodeIssueSeverity.style),
      isTrue,
    );

    expect(
      issues.map((issue) => issue.sourceSpan.start.offset),
      equals([102, 270, 397, 513]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.start.line),
      equals([11, 29, 43, 52]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.start.column),
      equals([3, 3, 3, 3]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.end.offset),
      equals([152, 326, 429, 552]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.text),
      equals([
        'if (a == 3) {\n'
            '    a = 2;\n'
            '  } else {\n'
            '    a = 3;\n'
            '  }',
        'if (a == 6) {\n'
            '    return a;\n'
            '  } else {\n'
            '    return 3;\n'
            '  }',
        'if (a == 9) a = 2;\n'
            '  else a = 3;',
        'if (a == 12) return 2;\n'
            '  else return a;',
      ]),
    );
    expect(
      issues.map((issue) => issue.message),
      equals([
        'Prefer conditional expression',
        'Prefer conditional expression',
        'Prefer conditional expression',
        'Prefer conditional expression',
      ]),
    );

    expect(
      issues.map((issue) => issue.correction),
      equals([
        'a = a == 3 ? 2 : 3;',
        'return a == 6 ? a : 3;',
        'a = a == 9 ? 2 : 3;',
        'return a == 12 ? 2 : a;',
      ]),
    );
    expect(
      issues.map((issue) => issue.correctionComment),
      equals([
        'Convert to conditional expression',
        'Convert to conditional expression',
        'Convert to conditional expression',
        'Convert to conditional expression',
      ]),
    );
  });
}
