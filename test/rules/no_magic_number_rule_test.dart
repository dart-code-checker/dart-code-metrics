import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/no_magic_number_rule.dart';
import 'package:test/test.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';

const _sample = '''
const pi = 3.14;
const pi2 = pi * 2;
const str = 'Hello';

number good_f1(number x) => x + 1;
bool good_f2(number x) => x != 0;
bool good_f3(String x) => x.indexOf(str) != -1
void good_f4(number x) => a * pi;
void good_f5() => good_f4(pi2);

number bad_f1(number x) => x + 42;
bool bad_f2(number x) => x != 12;
void bad_f4(number x) => a * 3.14;
void bad_f5() => bad_f4(12);
''';

void main() {
  group('NoMagicNumberRule', () {
    test('reports', () {
      final sourceUrl = Uri.parse('/example.dart');

      final parseResult = parseString(
          content: _sample,
          featureSet: FeatureSet.fromEnableFlags([]),
          throwIfDiagnostics: false);

      final issues = const NoMagicNumberRule()
          .check(parseResult.unit, sourceUrl, parseResult.content)
          .toList();

      expect(issues.length, equals(4));

      expect(
          issues.every((issue) => issue.ruleId == 'no-magic-number'), isTrue);
      expect(
          issues.every((issue) => issue.severity == CodeIssueSeverity.warning),
          isTrue);
      expect(issues.every((issue) => issue.sourceSpan.sourceUrl == sourceUrl),
          isTrue);
      expect(issues.map((issue) => issue.sourceSpan.start.offset),
          equals([273, 307, 340, 370]));
      expect(issues.map((issue) => issue.sourceSpan.start.line),
          equals([11, 12, 13, 14]));
      expect(issues.map((issue) => issue.sourceSpan.start.column),
          equals([32, 31, 30, 25]));
      expect(issues.map((issue) => issue.sourceSpan.end.offset),
          equals([275, 309, 344, 372]));
      expect(issues.map((issue) => issue.sourceSpan.text),
          equals(['42', '12', '3.14', '12']));
    });
  });
}
