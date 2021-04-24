@TestOn('vm')
import 'package:args/args.dart';
import 'package:dart_code_metrics/src/cli/arguments_validation.dart';
import 'package:dart_code_metrics/src/config/deprecated_option.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class ArgResultsMock extends Mock implements ArgResults {}

void main() {
  group('arguments validation', () {
    test(
      "checkPathsToAnalyzeNotEmpty emits exception when arguments doesn't contains any folder",
      () {
        final result = ArgResultsMock();

        when(() => result.rest).thenReturn([]);
        expect(
          () {
            checkPathsToAnalyzeNotEmpty(result);
          },
          throwsException,
        );

        when(() => result.rest).thenReturn(['lib']);
        checkPathsToAnalyzeNotEmpty(result);
      },
    );

    test(
      'checkDeprecatedArguments returns warnings for use deprecated arguments',
      () {
        final result = ArgResultsMock();

        when(() => result.wasParsed('option1')).thenReturn(true);
        when(() => result.wasParsed('option2')).thenReturn(true);

        expect(checkDeprecatedArguments(result, []), isEmpty);
        expect(
          checkDeprecatedArguments(result, [
            const DeprecatedOption(
              supportUntilVersion: '1.1',
              deprecated: 'option1',
              replacement: 'option 1',
            ),
            const DeprecatedOption(
              supportUntilVersion: '1.2',
              deprecated: 'option2',
            ),
          ]),
          equals([
            'option1 deprecated argument, please use option 1. This argument will be removed in 1.1 version.',
            'option2 deprecated argument. This argument will be removed in 1.2 version.',
          ]),
        );
      },
    );
  });
}
