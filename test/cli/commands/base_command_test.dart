import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_code_metrics/src/cli/commands/base_command.dart';
import 'package:dart_code_metrics/src/cli/exceptions/arguments_validation_exceptions.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class DirectoryMock extends Mock implements Directory {}

void main() {
  group('BaseCommand', () {
    final result = ArgResultsMock();
    final command = TestCommand(result);

    test('should throw invalid number of directories exception', () {
      when(() => result.rest).thenReturn([]);

      expect(
        command.validateTargetDirectories,
        throwsA(predicate((e) =>
            e is InvalidArgumentException &&
            e.message ==
                'Invalid number of directories. At least one must be specified.')),
      );
    });

    test("should throw path doesn't exist", () {
      when(() => result.rest).thenReturn(['bil']);
      when(() => result['root-folder'] as String).thenReturn('./');

      expect(
        command.validateTargetDirectories,
        throwsA(predicate(
          (e) =>
              e is InvalidArgumentException &&
              e.message == "./bil doesn't exist or isn't a directory.",
        )),
      );
    });

    test(
      "should throw if 'sdk-path' directory is specified but doesn't exist",
      () {
        final directory = DirectoryMock();
        when(() => result['sdk-path'] as String).thenReturn('SDK_PATH');
        when(directory.existsSync).thenReturn(false);

        expect(
          command.validateSdkPath,
          throwsA(predicate(
            (e) =>
                e is InvalidArgumentException &&
                e.message ==
                    'Dart SDK path SDK_PATH does not exist or not a directory.',
          )),
        );
      },
    );
  });
}

class ArgResultsMock extends Mock implements ArgResults {}

class TestCommand extends BaseCommand {
  final ArgResults _results;

  TestCommand(this._results);

  @override
  ArgResults get argResults => _results;

  @override
  String get name => 'test';

  @override
  String get description => 'empty';

  @override
  void validateCommand() {
    throw UnimplementedError();
  }

  @override
  Future<void> runCommand() {
    throw UnimplementedError();
  }
}
