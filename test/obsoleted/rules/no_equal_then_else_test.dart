@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/no_equal_then_else.dart';
import 'package:test/test.dart';

// ignore_for_file: no_adjacent_strings_in_list

const _content = '''

int value1 = 1;
int value2 = 2;

int testFunction() {
  if (value1 == 1) {
    return value1;
  } else {
    return value1;
  }

  if (value1 == 2) {
    return value2;
  } else {
    return value1;
  }

  if (value1 == 3) {
    return value1;
  }

  if (value1 == 4) {
    value1 = 2;
  } else {
    value1 = 2;
  }

  if (value1 == 5) 
    value1 = 2;
  else 
    value1 = 2;
  
  if (value1 == 6) {
    value1 = 5;
  } else if (value1 == 7) {
    value1 = 5;
  }

  if (value1 == 8) {
    value1 = 5;
  } else if (value1 == 9) {
    value1 = 5;
  } else {
    value1 = 5;
  }

  if (value1 == 10) {
    value1 = 5;
  }
}

int anotherTestFunction() {
  if (value2 == 1) {
    return value1 == 11 ? value1 : value1;
  }

  return value1 == 12 ? value1 : value2;
}

''';

void main() {
  group('EqualThenElse', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
      content: _content,
      // ignore: deprecated_member_use
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    test('initialization', () {
      final issues = NoEqualThenElse().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.every((issue) => issue.ruleId == 'no-equal-then-else'),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.severity == Severity.warning),
        isTrue,
      );
    });

    test('reports about found issues', () {
      final issues = NoEqualThenElse().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.map((issue) => issue.location.start.offset),
        equals([57, 252, 321, 514, 686]),
      );
      expect(
        issues.map((issue) => issue.location.start.line),
        equals([6, 22, 28, 41, 54]),
      );
      expect(
        issues.map((issue) => issue.location.start.column),
        equals([3, 3, 3, 10, 12]),
      );
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals([128, 317, 378, 579, 716]),
      );
      expect(
        issues.map((issue) => issue.location.text),
        equals([
          'if (value1 == 1) {\n'
              '    return value1;\n'
              '  } else {\n'
              '    return value1;\n'
              '  }',
          'if (value1 == 4) {\n'
              '    value1 = 2;\n'
              '  } else {\n'
              '    value1 = 2;\n'
              '  }',
          'if (value1 == 5) \n'
              '    value1 = 2;\n'
              '  else \n'
              '    value1 = 2;',
          'if (value1 == 9) {\n'
              '    value1 = 5;\n'
              '  } else {\n'
              '    value1 = 5;\n'
              '  }',
          'value1 == 11 ? value1 : value1',
        ]),
      );
      expect(
        issues.map((issue) => issue.message),
        equals([
          'Then and else branches are equal',
          'Then and else branches are equal',
          'Then and else branches are equal',
          'Then and else branches are equal',
          'Then and else branches are equal',
        ]),
      );
    });
  });
}
