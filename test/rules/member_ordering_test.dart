@TestOn('vm')

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/member_ordering.dart';
import 'package:test/test.dart';

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
  test('MemberOrdering reports about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
        content: _content,
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false);

    final issues = const MemberOrderingRule()
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
        'constructor should be before angular_outputs',
      ]),
    );
  });
}
