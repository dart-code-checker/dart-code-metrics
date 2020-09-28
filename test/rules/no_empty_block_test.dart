@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/no_empty_block.dart';
import 'package:test/test.dart';

const _content = '''

int simpleFunction() {
  try {
    
  } catch (_) {}

  var a = 4;

  if (a > 70) {

  } else if (a > 65) {

  // TODO(developername): message.

  } else if (a > 60) {
    return a + 2;
  }

  [1, 2, 3, 4].forEach((val) {});

  [1, 2, 3, 4].forEach((val) {
    // TODO(developername): need to implement.
  });

  return a;
}

void emptyFunction() {}

void emptyFunction2() {
  // TODO(developername): need to implement.
}

''';

void main() {
  test('NoEmptyBlockRule reports about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
        content: _content,
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false);

    final issues = NoEmptyBlockRule()
        .check(parseResult.unit, sourceUrl, parseResult.content);

    expect(issues.length, equals(4));

    expect(issues.every((issue) => issue.ruleId == 'no-empty-block'), isTrue);
    expect(issues.every((issue) => issue.severity == CodeIssueSeverity.style),
        isTrue);
    expect(issues.every((issue) => issue.sourceSpan.sourceUrl == sourceUrl),
        isTrue);
    expect(issues.map((issue) => issue.sourceSpan.start.offset),
        equals([30, 83, 221, 348]));
    expect(issues.map((issue) => issue.sourceSpan.start.line),
        equals([3, 9, 19, 28]));
    expect(issues.map((issue) => issue.sourceSpan.start.column),
        equals([7, 15, 30, 22]));
    expect(issues.map((issue) => issue.sourceSpan.end.offset),
        equals([40, 89, 223, 350]));
    expect(issues.map((issue) => issue.sourceSpan.text),
        equals(['{\n    \n  }', '{\n\n  }', '{}', '{}']));
    expect(
        issues.map((issue) => issue.message),
        equals([
          'Block is empty. Empty blocks are often indicators of missing code.',
          'Block is empty. Empty blocks are often indicators of missing code.',
          'Block is empty. Empty blocks are often indicators of missing code.',
          'Block is empty. Empty blocks are often indicators of missing code.',
        ]));
    expect(issues.map((issue) => issue.correction),
        equals([null, null, null, null]));
    expect(issues.map((issue) => issue.correctionComment),
        equals([null, null, null, null]));
  });
}
