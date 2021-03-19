@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/no_empty_block.dart';
import 'package:test/test.dart';

const _content = '''

int simpleFunction() {
  try {
    
  } catch (_) {}

  var a = 4;

  if (a > 70) {

  } else if (a > 65) {

  // TODO(developerName): message.

  } else if (a > 60) {
    return a + 2;
  }

  [1, 2, 3, 4].forEach((val) {});

  [1, 2, 3, 4].forEach((val) {
    // TODO(developerName): need to implement.
  });

  return a;
}

void emptyFunction() {}

void emptyFunction2() {
  // TODO(developerName): need to implement.
}

''';

void main() {
  test('NoEmptyBlockRule reports about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
      content: _content,
      // ignore: deprecated_member_use
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    final issues = NoEmptyBlockRule().check(InternalResolvedUnitResult(
      sourceUrl,
      parseResult.content,
      parseResult.unit,
    ));

    expect(issues, hasLength(4));

    expect(issues.every((issue) => issue.ruleId == 'no-empty-block'), isTrue);
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
      equals([30, 83, 221, 348]),
    );
    expect(
      issues.map((issue) => issue.location.start.line),
      equals([3, 9, 19, 28]),
    );
    expect(
      issues.map((issue) => issue.location.start.column),
      equals([7, 15, 30, 22]),
    );
    expect(
      issues.map((issue) => issue.location.end.offset),
      equals([40, 89, 223, 350]),
    );
    expect(
      issues.map((issue) => issue.location.text),
      equals(['{\n    \n  }', '{\n\n  }', '{}', '{}']),
    );
    expect(
      issues.map((issue) => issue.message),
      equals([
        'Block is empty. Empty blocks are often indicators of missing code.',
        'Block is empty. Empty blocks are often indicators of missing code.',
        'Block is empty. Empty blocks are often indicators of missing code.',
        'Block is empty. Empty blocks are often indicators of missing code.',
      ]),
    );
    expect(
      issues.map((issue) => issue.suggestion),
      equals([null, null, null, null]),
    );
  });
}
