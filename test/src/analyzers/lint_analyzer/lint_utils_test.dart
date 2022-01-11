import 'package:dart_code_metrics/src/analyzers/lint_analyzer/lint_utils.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:test/test.dart';

void main() {
  group('Lint utils', () {
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

    group('readExcludes', () {
      test('returns a list of excludes', () {
        const excludes = ['hello.dart', 'world/**'];

        expect(readExcludes({'exclude': excludes}), equals(excludes));
      });

      test('returns an empty list', () {
        const wrongExcludes = [1, 2];

        expect(readExcludes({'exclude': wrongExcludes}), isEmpty);
      });
    });
  });
}
