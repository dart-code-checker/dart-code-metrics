import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_code_metrics/src/cli/commands/base_command.dart';
import 'package:dart_code_metrics/src/cli/exceptions/invalid_argument_exception.dart';
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
        command.validateTargetDirectoriesOrFiles,
        throwsA(predicate((e) =>
            e is InvalidArgumentException &&
            e.message ==
                'Invalid number of directories or files. At least one must be specified.')),
      );
    });

    test("should throw path doesn't exist", () {
      when(() => result.rest).thenReturn(['bil']);
      when(() => result['root-folder'] as String).thenReturn('./');

      expect(
        command.validateTargetDirectoriesOrFiles,
        throwsA(predicate(
          (e) =>
              e is InvalidArgumentException &&
              e.message ==
                  "./bil doesn't exist or isn't a directory or a file.",
        )),
      );
    });

    test(
      "should throw if 'sdk-path' directory is specified but doesn't exist",
      () {
        when(() => result['sdk-path'] as String).thenReturn('SDK_PATH');
        IOOverrides.runZoned(
          () {
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
          createDirectory: (path) {
            final directory = DirectoryMock();
            when(directory.existsSync).thenReturn(false);

            return directory;
          },
        );
      },
    );

    test(
      "should not detect sdk path if 'sdk-path' option is specified",
      () {
        when(() => result['sdk-path'] as String).thenReturn('SDK_PATH');

        expect(command.findSdkPath(), equals('SDK_PATH'));
      },
    );

    test(
      "should not throw on 'validateCommand' call if correct options passed",
      () {
        when(() => result['root-folder'] as String).thenReturn('');
        when(() => result['sdk-path'] as String).thenReturn('');
        when(() => result.rest).thenReturn(['']);

        IOOverrides.runZoned(
          () {
            expect(command.validateCommand, returnsNormally);
          },
          createDirectory: (path) {
            final directory = DirectoryMock();
            when(directory.existsSync).thenReturn(true);

            return directory;
          },
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
  Future<void> runCommand() {
    throw UnimplementedError();
  }
}
