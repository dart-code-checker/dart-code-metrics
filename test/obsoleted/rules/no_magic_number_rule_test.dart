@TestOn('vm')
import 'package:code_checker/rules.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/no_magic_number_rule.dart';
import 'package:test/test.dart';

const _sampleGood = '''
const pi = 3.14;
const pi2 = pi * 2;
const str = 'Hello';

void good_f4(number x) => a * pi;
void good_f5() => good_f4(pi2);
''';

const _sampleBad = '''
number bad_f1(number x) => x + 42;
bool bad_f2(number x) => x != 12;
void bad_f4(number x) => a * 3.14;
void bad_f5() => bad_f4(12);
''';

const _sampleExceptions = '''
number good_f1(number x) => x + 1;
bool good_f2(number x) => x != 0;
bool good_f3(String x) => x.indexOf(str) != -1
final someDay = DateTime(2006, 12, 1);
Intl.message(example: const <String, int>{ 'Assigned': 3 });
foo(const [32, 12]);
final f = Future.delayed(const Duration(seconds: 5));
final f = foo(const Bar(5));
''';

void main() {
  final sourceUrl = Uri.parse('/example.dart');
  group('NoMagicNumberRule', () {
    test('reports magic numbers', () {
      final parseResult = parseString(
        content: _sampleBad,
        // ignore: deprecated_member_use
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false,
      );

      final issues = NoMagicNumberRule()
          .check(InternalResolvedUnitResult(
            sourceUrl,
            parseResult.content,
            parseResult.unit,
          ))
          .toList();

      expect(issues, hasLength(4));

      expect(
        issues.every((issue) => issue.ruleId == 'no-magic-number'),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.severity == Severity.warning),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.location.sourceUrl == sourceUrl),
        isTrue,
      );
      expect(
        issues.map((issue) => issue.location.start.offset),
        equals([31, 65, 98, 128]),
      );
      expect(
        issues.map((issue) => issue.location.start.line),
        equals([1, 2, 3, 4]),
      );
      expect(
        issues.map((issue) => issue.location.start.column),
        equals([32, 31, 30, 25]),
      );
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals([33, 67, 102, 130]),
      );
      expect(
        issues.map((issue) => issue.location.text),
        equals(['42', '12', '3.14', '12']),
      );
    });

    test("doesn't report constants", () {
      final parseResult = parseString(
        content: _sampleGood,
        // ignore: deprecated_member_use
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false,
      );

      final issues = NoMagicNumberRule()
          .check(InternalResolvedUnitResult(
            sourceUrl,
            parseResult.content,
            parseResult.unit,
          ))
          .toList();

      expect(issues, isEmpty);
    });

    test("doesn't report exceptional code", () {
      final parseResult = parseString(
        content: _sampleExceptions,
        // ignore: deprecated_member_use
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false,
      );

      final issues = NoMagicNumberRule()
          .check(InternalResolvedUnitResult(
            sourceUrl,
            parseResult.content,
            parseResult.unit,
          ))
          .toList();

      expect(issues, isEmpty);
    });

    test("doesn't report magic numbers allowed in config", () {
      final parseResult = parseString(
        content: _sampleBad,
        // ignore: deprecated_member_use
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false,
      );

      final issues = NoMagicNumberRule(config: {
        'allowed': [42, 12, 3.14],
      })
          .check(InternalResolvedUnitResult(
            sourceUrl,
            parseResult.content,
            parseResult.unit,
          ))
          .toList();

      expect(issues, isEmpty);
    });
  });
}
