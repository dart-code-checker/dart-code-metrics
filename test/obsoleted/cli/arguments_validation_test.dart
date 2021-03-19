@TestOn('vm')
import 'package:args/args.dart';
import 'package:dart_code_metrics/src/obsoleted/config/cli/arguments_validation.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ArgResultsMock extends Mock implements ArgResults {}

void main() {
  group('arguments validator', () {
    group('checkPathsToAnalyzeNotEmpty', () {
      test("emits exception when arguments doesn't contains any folder", () {
        final result = ArgResultsMock();
        when(result.rest).thenReturn([]);

        expect(
          () {
            checkPathsToAnalyzeNotEmpty(result);
          },
          throwsException,
        );
      });
    });
  });
}
