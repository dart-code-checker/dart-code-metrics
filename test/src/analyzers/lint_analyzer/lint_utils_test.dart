import 'package:dart_code_metrics/src/analyzers/lint_analyzer/lint_utils.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:test/test.dart';

void main() {
  test('readSeverity returns a Severity from Map based config', () {
    expect(
      [
        {'severity': 'ERROR'},
        {'severity': 'wArnInG'},
        {'severity': 'performance'},
        {'severity': ''},
        {'': null},
      ].map((data) => readSeverity(data, Severity.style)),
      equals([
        Severity.error,
        Severity.warning,
        Severity.performance,
        Severity.none,
        Severity.style,
      ]),
    );
  });
}
