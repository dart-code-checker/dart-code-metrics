@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/double_literal_format_rule.dart';
import 'package:test/test.dart';

const _content = '''

void main() {
  var a = [05.23, 5.23, 03.6e+5, 3.6e+5, -012.2, -12.2, -01.1e-1, -1.1e-1];

  var b = [.257, 0.257, .16e+5, 0.16e+5, -.259, -0.259, -.14e-5, -0.14e-5];

  var c = [0.210, 0.21, 0.10e+5, 0.1e+5, -0.250, -0.25, -0.40e-5, -0.4e-5];
  
  var d = [0.0, -0.0, 12.0e+1, 150, 0x015, 0x020];
}

''';

void main() {
  test('DoubleLiteralFormatRule report about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
        content: _content,
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false);

    final issues =
        const DoubleLiteralFormatRule().check(parseResult.unit, sourceUrl);

    expect(issues.length, equals(12));

    expect(issues.map((issue) => issue.ruleId).toSet().single,
        equals('double-literal-format'));
    expect(issues.map((issue) => issue.severity).toSet().single,
        equals(CodeIssueSeverity.style));
    expect(issues.map((issue) => issue.sourceSpan.sourceUrl).toSet().single,
        equals(sourceUrl));
    expect(issues.map((issue) => issue.sourceSpan.start.offset),
        equals([26, 39, 57, 72, 103, 116, 134, 149, 180, 193, 211, 226]));
    expect(issues.map((issue) => issue.sourceSpan.start.line),
        equals([3, 3, 3, 3, 5, 5, 5, 5, 7, 7, 7, 7]));
    expect(issues.map((issue) => issue.sourceSpan.start.column),
        equals([12, 25, 43, 58, 12, 25, 43, 58, 12, 25, 43, 58]));
    expect(issues.map((issue) => issue.sourceSpan.end.offset),
        equals([31, 46, 62, 79, 107, 122, 138, 155, 185, 200, 216, 233]));
    expect(
        issues.map((issue) => issue.sourceSpan.text),
        equals([
          '05.23',
          '03.6e+5',
          '012.2',
          '01.1e-1',
          '.257',
          '.16e+5',
          '.259',
          '.14e-5',
          '0.210',
          '0.10e+5',
          '0.250',
          '0.40e-5',
        ]));
    expect(
        issues.map((issue) => issue.message),
        equals([
          "Double literal shouldn\'t have redundant leading '0'.",
          "Double literal shouldn\'t have redundant leading '0'.",
          "Double literal shouldn\'t have redundant leading '0'.",
          "Double literal shouldn\'t have redundant leading '0'.",
          "Double literal shouldn\'t begin with '.'.",
          "Double literal shouldn\'t begin with '.'.",
          "Double literal shouldn\'t begin with '.'.",
          "Double literal shouldn\'t begin with '.'.",
          "Double literal shouldn\'t have a trailing '0'.",
          "Double literal shouldn\'t have a trailing '0'.",
          "Double literal shouldn\'t have a trailing '0'.",
          "Double literal shouldn\'t have a trailing '0'.",
        ]));
    expect(
        issues.map((issue) => issue.correction),
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
        ]));
    expect(
        issues.map((issue) => issue.correctionComment),
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
        ]));
  });
}
