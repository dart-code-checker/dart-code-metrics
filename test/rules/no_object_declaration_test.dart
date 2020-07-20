@TestOn('vm')

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/no_object_declaration.dart';
import 'package:test/test.dart';

// ignore_for_file: no_adjacent_strings_in_list

const _content = '''

class Test {
    Object data = 1;

    Object get getter => 1;

    Object doWork() {
      return null;
    }
}

class AnotherTest {
    int data = 1;

    int get getter => 1;

    void doWork() {
      return;
    }

    void doAnotherWork(Object param) {
      return;
    }
}

Object a = 1;

Object function(Object param) {
  return null;
}

''';

void main() {
  test('NoObjectDeclarationRule reports about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
        content: _content,
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false);

    final issues = const NoObjectDeclarationRule()
        .check(parseResult.unit, sourceUrl, parseResult.content);

    expect(
      issues.every((issue) => issue.ruleId == 'no-object-declaration'),
      isTrue,
    );
    expect(
      issues.every((issue) => issue.severity == CodeIssueSeverity.style),
      isTrue,
    );

    expect(
      issues.map((issue) => issue.sourceSpan.start.offset),
      equals([18, 40, 69]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.start.line),
      equals([3, 5, 7]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.start.column),
      equals([5, 5, 5]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.end.offset),
      equals([34, 63, 106]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.text),
      equals([
        'Object data = 1;',
        'Object get getter => 1;',
        'Object doWork() {\n'
            '      return;\n'
            '    }',
      ]),
    );
    expect(
      issues.map((issue) => issue.message),
      equals([
        'Avoid Object type declaration in class member',
        'Avoid Object type declaration in class member',
        'Avoid Object type declaration in class member',
      ]),
    );
  });
}
