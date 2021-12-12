import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:test/test.dart';

void main() {
  test('Severity fromString converts string to Severity object', () {
    expect(
      ['nOne', 'StyLe', 'wArnInG', 'erROr', '', null].map(Severity.fromString),
      equals([
        Severity.none,
        Severity.style,
        Severity.warning,
        Severity.error,
        Severity.none,
        null,
      ]),
    );
  });
}
