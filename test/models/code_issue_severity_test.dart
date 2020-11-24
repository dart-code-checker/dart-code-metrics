@TestOn('vm')

import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:test/test.dart';

void main() {
  test('CodeIssueSeverity fromJson constructs object from string', () {
    expect(
      ['StyLe', 'wArnInG', 'erROr', '']
          .map(CodeIssueSeverity.fromJson)
          .map((severity) => severity?.value),
      equals([
        CodeIssueSeverity.style.value,
        CodeIssueSeverity.warning.value,
        CodeIssueSeverity.error.value,
        null,
      ]),
    );
  });
}
