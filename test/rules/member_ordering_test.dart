@TestOn('vm')

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/member_ordering.dart';
import 'package:test/test.dart';

// ignore_for_file: no_adjacent_strings_in_list

const _content = '''

class Test {
  void doWork  {

  }

  final data = 1;

  @Input()
  String input;

  @Output()
  Stream<void> get click => null;

  Test();
}

''';

void main() {
  final sourceUrl = Uri.parse('/example.dart');
  final parseResult = parseString(
      content: _content,
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false);

  test('MemberOrdering with default config reports about found issues', () {
    final issues = MemberOrderingRule()
        .check(parseResult.unit, sourceUrl, parseResult.content);

    expect(issues.every((issue) => issue.ruleId == 'member-ordering'), isTrue);
    expect(issues.every((issue) => issue.severity == CodeIssueSeverity.style),
        isTrue);

    expect(
      issues.map((issue) => issue.sourceSpan.start.offset),
      equals([39, 133]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.start.line),
      equals([7, 15]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.start.column),
      equals([3, 3]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.end.offset),
      equals([54, 140]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.text),
      equals(['final data = 1;', 'Test();']),
    );
    expect(
      issues.map((issue) => issue.message),
      equals([
        'public_fields should be before public_methods',
        'constructors should be before angular_outputs',
      ]),
    );
  });

  test('MemberOrdering with custom config reports about found issues', () {
    final config = {
      'order': [
        'constructors',
        'angular_inputs',
        'public_fields',
        'public_methods',
      ],
    };

    final issues = MemberOrderingRule(config: config)
        .check(parseResult.unit, sourceUrl, parseResult.content);

    expect(
      issues.map((issue) => issue.sourceSpan.start.offset),
      equals([39, 58, 133]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.start.line),
      equals([7, 9, 15]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.start.column),
      equals([3, 3, 3]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.end.offset),
      equals([54, 82, 140]),
    );
    expect(
      issues.map((issue) => issue.sourceSpan.text),
      equals([
        'final data = 1;',
        '@Input()\n'
            '  String input;',
        'Test();',
      ]),
    );
    expect(
      issues.map((issue) => issue.message),
      equals([
        'public_fields should be before public_methods',
        'angular_inputs should be before public_fields',
        'constructors should be before angular_inputs',
      ]),
    );
  });
}
