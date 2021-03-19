@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/double_literal_format_rule.dart';
import 'package:test/test.dart';

const _content = '''

void main() {
  var a = [05.23, 5.23, 003.6e+5, 3.6e+5, -012.2, -12.2, -001.1e-1, -1.1e-1];

  var b = [.257, 0.257, .16e+5, 0.16e+5, -.259, -0.259, -.14e-5, -0.14e-5];

  var c = [0.2100, 0.21, 0.100e+5, 0.1e+5, -0.2500, -0.25, -0.400e-5, -0.4e-5];
  
  var d = [0.0, -0.0, 12.0e+1, 150, 0x015, 0x020];
}

''';

void main() {
  group('DoubleLiteralFormatRule', () {
    group('util function', () {
      test('detectLeadingZero', () {
        expect(
          ['05.23', '5.23', '003.6e+5', '3.6e+5', '0.1'].map(detectLeadingZero),
          equals([true, false, true, false, false]),
        );
      });

      test('leadingZeroCorrection', () {
        expect(
          ['05.23', '5.23', '003.6e+5', '3.6e+5', '0.1']
              .map(leadingZeroCorrection),
          equals(['5.23', '5.23', '3.6e+5', '3.6e+5', '0.1']),
        );
      });

      test('detectLeadingDecimal', () {
        expect(
          ['.257', '0.257', '.16e+5', '0.16e+5'].map(detectLeadingDecimal),
          equals([true, false, true, false]),
        );
      });

      test('leadingDecimalCorrection', () {
        expect(
          ['.257', '0.257', '.16e+5', '0.16e+5'].map(leadingDecimalCorrection),
          equals(['0.257', '0.257', '0.16e+5', '0.16e+5']),
        );
      });

      test('detectTrailingZero', () {
        expect(
          ['0.2100', '0.21', '0.100e+5', '0.1e+5'].map(detectTrailingZero),
          equals([true, false, true, false]),
        );
      });

      test('trailingZeroCorrection', () {
        expect(
          ['0.2100', '0.21', '0.100e+5', '0.1e+5'].map(trailingZeroCorrection),
          equals(['0.21', '0.21', '0.1e+5', '0.1e+5']),
        );
      });
    });

    test('report about found issues', () {
      final sourceUrl = Uri.parse('/example.dart');

      final parseResult = parseString(
        content: _content,
        // ignore: deprecated_member_use
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false,
      );

      final issues = DoubleLiteralFormatRule().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(issues, hasLength(12));

      expect(
        issues.every((issue) => issue.ruleId == 'double-literal-format'),
        isTrue,
      );
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
        equals([26, 39, 58, 73, 105, 118, 136, 151, 182, 196, 215, 231]),
      );
      expect(
        issues.map((issue) => issue.location.start.line),
        equals([3, 3, 3, 3, 5, 5, 5, 5, 7, 7, 7, 7]),
      );
      expect(
        issues.map((issue) => issue.location.start.column),
        equals([12, 25, 44, 59, 12, 25, 43, 58, 12, 26, 45, 61]),
      );
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals([31, 47, 63, 81, 109, 124, 140, 157, 188, 204, 221, 239]),
      );
      expect(
        issues.map((issue) => issue.location.text),
        equals([
          '05.23',
          '003.6e+5',
          '012.2',
          '001.1e-1',
          '.257',
          '.16e+5',
          '.259',
          '.14e-5',
          '0.2100',
          '0.100e+5',
          '0.2500',
          '0.400e-5',
        ]),
      );
      expect(
        issues.map((issue) => issue.message),
        equals([
          "Double literal shouldn't have redundant leading '0'.",
          "Double literal shouldn't have redundant leading '0'.",
          "Double literal shouldn't have redundant leading '0'.",
          "Double literal shouldn't have redundant leading '0'.",
          "Double literal shouldn't begin with '.'.",
          "Double literal shouldn't begin with '.'.",
          "Double literal shouldn't begin with '.'.",
          "Double literal shouldn't begin with '.'.",
          "Double literal shouldn't have a trailing '0'.",
          "Double literal shouldn't have a trailing '0'.",
          "Double literal shouldn't have a trailing '0'.",
          "Double literal shouldn't have a trailing '0'.",
        ]),
      );
      expect(
        issues.map((issue) => issue.suggestion.replacement),
        equals([
          '5.23',
          '3.6e+5',
          '12.2',
          '1.1e-1',
          '0.257',
          '0.16e+5',
          '0.259',
          '0.14e-5',
          '0.21',
          '0.1e+5',
          '0.25',
          '0.4e-5',
        ]),
      );
      expect(
        issues.map((issue) => issue.suggestion.comment),
        equals([
          "Remove redundant leading '0'",
          "Remove redundant leading '0'",
          "Remove redundant leading '0'",
          "Remove redundant leading '0'",
          "Add missing leading '0'",
          "Add missing leading '0'",
          "Add missing leading '0'",
          "Add missing leading '0'",
          "Remove redundant trailing '0'",
          "Remove redundant trailing '0'",
          "Remove redundant trailing '0'",
          "Remove redundant trailing '0'",
        ]),
      );
    });
  });
}
