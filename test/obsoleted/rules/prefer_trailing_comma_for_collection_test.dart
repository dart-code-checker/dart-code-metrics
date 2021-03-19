@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/prefer_trailing_comma_for_collection.dart';
import 'package:test/test.dart';

const _content = '''
//Correct

final a = [1, 2, 3];
final b = <int>[1, 2, 3];
var c = {'a', 'b'};
var d = {'a': 1, 'b': 2};
final c = <Object>[const A('a1'), const A('a2'), const A('a3')];

final a = [
  1, 
  2, 
  3,
];
final b = <int>[1, 2, 
  3,
];
var c = {
  'a',
  'b',
};
var d = {
  'a': 1, 
  'b': 2,
};

final c = <Object>[
  const A('a1'), 
  const A('a2'), 
  const A('a3'),
];

//Issues

final a0 = [
  1
];

final a = [
  1227, 
  2178, 
  3
];

final b = <int>[1, 
  2, 
  3
];

final c = <Object>[
  const A('a1'), 
  const A('a2'), 
  const A('a3') 
];


var d = {
  'a', 
  'b'
};

var e = {
  'a': 1, 
  'b': 2
};

var e = <String, int>{'a': 1, 
  'b': 2,
  'c': 3,
  if (true)
    'e': 10
};
''';

void main() {
  test('PreferTrailingCommasForCollectionRule reports about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
      content: _content,
      // ignore: deprecated_member_use
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    final issues =
        PreferTrailingCommaForCollectionRule().check(InternalResolvedUnitResult(
      sourceUrl,
      parseResult.content,
      parseResult.unit,
    ));

    expect(issues, hasLength(7));

    expect(
      issues.every(
        (issue) => issue.ruleId == 'prefer-trailing-comma-for-collection',
      ),
      isTrue,
    );
    expect(
      issues.every((issue) => issue.severity == Severity.style),
      isTrue,
    );
    expect(
      issues.every((i) => i.message == 'A trailing comma should end this line'),
      isTrue,
    );

    expect(
      issues.map((issue) => issue.suggestion.replacement),
      equals([
        '1,',
        '3,',
        '3,',
        "const A('a3'),",
        "'b',",
        "'b': 2,",
        "if (true)\n    'e': 10,",
      ]),
    );

    expect(
      issues.every((issue) => issue.suggestion.comment == 'Add trailing comma'),
      isTrue,
    );
    expect(
      issues.every((issue) => issue.location.sourceUrl == sourceUrl),
      isTrue,
    );
    expect(
      issues.every((issue) => issue.location.sourceUrl == sourceUrl),
      isTrue,
    );

    expect(
      issues.map((issue) => issue.location.start.offset),
      equals([397, 435, 469, 533, 573, 604, 668]),
    );
    expect(
      issues.map((issue) => issue.location.start.line),
      equals([35, 41, 46, 52, 58, 63, 69]),
    );
    expect(
      issues.map((issue) => issue.location.start.column),
      equals([3, 3, 3, 3, 3, 3, 3]),
    );

    expect(
      issues.map((issue) => issue.location.end.offset),
      equals([398, 436, 470, 546, 576, 610, 689]),
    );
    expect(
      issues.map((issue) => issue.location.end.line),
      equals([35, 41, 46, 52, 58, 63, 70]),
    );
    expect(
      issues.map((issue) => issue.location.end.column),
      equals([4, 4, 4, 16, 6, 9, 12]),
    );

    expect(
      issues.map((issue) => issue.location.text),
      equals([
        '1',
        '3',
        '3',
        "const A('a3')",
        "'b'",
        "'b': 2",
        "if (true)\n    'e': 10",
      ]),
    );
  });
}
