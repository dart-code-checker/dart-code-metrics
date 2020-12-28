@TestOn('vm')
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/analysis.dart';
import 'package:dart_code_metrics/src/rules/no_object_declaration.dart';
import 'package:test/test.dart';

// ignore_for_file: no_adjacent_strings_in_list

const examplePath = 'test/rules/no_object_declaration/examples/example.dart';

void main() {
  test('NoObjectDeclarationRule reports about found issues', () async {
    final path = File(examplePath).absolute.path;
    final sourceUrl = Uri.parse(path);

    final parseResult = await resolveFile(path: path);

    final issues = NoObjectDeclarationRule()
        .check(ProcessedFile(sourceUrl, parseResult.content, parseResult.unit));

    expect(
      issues.every((issue) => issue.ruleId == 'no-object-declaration'),
      isTrue,
    );
    expect(
      issues.every((issue) => issue.severity == Severity.style),
      isTrue,
    );

    expect(
      issues.map((issue) => issue.sourceSpan.start.offset),
      equals([15, 35, 62]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.start.line),
      equals([2, 4, 6]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.start.column),
      equals([3, 3, 3]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.end.offset),
      equals([31, 58, 100]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.text),
      equals([
        'Object data = 1;',
        'Object get getter => 1;',
        'Object doWork() {\n'
            '    return null;\n'
            '  }',
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
