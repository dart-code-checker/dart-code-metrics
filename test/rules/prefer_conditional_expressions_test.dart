@TestOn('vm')

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/models/source.dart';
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

  if (a == 9) {
    return a;
  } else return 3;

  if (a == 10) return a;
  else {
    return 3;
  }

  if (a == 11) {
    a = 2;
  } else a = 3;

  if (a == 12) a = 2;
  else {
    a = 3;
  }

  if (a == 13) a = 2;
  else {
    return 3;
  }

  if (a == 14) return a;
  else {
    a = 3;
  }

  if (a == 15) {
    a = 2;
  } else return a;

  if (a == 16) {
    return 2;
  } else a = 3;

  if (a == 17) a = 2;
  else a = 3;

  if (a == 18) return a;
  else a = 3;

  if (a == 19) a = 2;
  else return a;

  if (a == 20) return 2;
  else return a;

  if (a == 21) return a;

  if (a == 22) a = 3;
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

  if (a == 4) {
    a = 4;
  } else if (a == 5) {
    a = 5;
  } else {
    a = 6;
  }
}

''';

void main() {
  test('PreferConditionalExpressions reports about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
        content: _content,
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false);

    final issues = PreferConditionalExpressions()
        .check(Source(sourceUrl, parseResult.content, parseResult.unit));

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
      equals([102, 270, 397, 447, 500, 545, 788, 905]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.start.line),
      equals([11, 29, 43, 47, 52, 56, 79, 88]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.start.column),
      equals([3, 3, 3, 3, 3, 3, 3, 3]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.end.offset),
      equals([152, 326, 443, 496, 541, 588, 821, 944]),
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
        'if (a == 9) {\n'
            '    return a;\n'
            '  } else return 3;',
        'if (a == 10) return a;\n'
            '  else {\n'
            '    return 3;\n'
            '  }',
        'if (a == 11) {\n'
            '    a = 2;\n'
            '  } else a = 3;',
        'if (a == 12) a = 2;\n'
            '  else {\n'
            '    a = 3;\n'
            '  }',
        'if (a == 17) a = 2;\n'
            '  else a = 3;',
        'if (a == 20) return 2;\n'
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
        'return a == 9 ? a : 3;',
        'return a == 10 ? a : 3;',
        'a = a == 11 ? 2 : 3;',
        'a = a == 12 ? 2 : 3;',
        'a = a == 17 ? 2 : 3;',
        'return a == 20 ? 2 : a;',
      ]),
    );
    expect(
      issues.map((issue) => issue.correctionComment),
      equals([
        'Convert to conditional expression',
        'Convert to conditional expression',
        'Convert to conditional expression',
        'Convert to conditional expression',
        'Convert to conditional expression',
        'Convert to conditional expression',
        'Convert to conditional expression',
        'Convert to conditional expression',
      ]),
    );
  });
}
