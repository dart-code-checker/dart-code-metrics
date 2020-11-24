@TestOn('vm')

import 'package:dart_code_metrics/src/models/violation_level.dart';
import 'package:test/test.dart';

void main() {
  test('ViolationLevel fromString constructs object from string', () {
    expect(
      ['noNE', 'NoTed', 'warning', 'ALARM', '']
          .map((level) => ViolationLevel.fromString(level)),
      equals([
        ViolationLevel.none,
        ViolationLevel.noted,
        ViolationLevel.warning,
        ViolationLevel.alarm,
        null,
      ]),
    );
  });
}
