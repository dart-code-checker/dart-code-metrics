import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_code_metrics/src/analyzers/unused_code_analyzer/models/unused_code_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/unused_code_analyzer/reporters/reporters_list/console/unused_code_console_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/unused_code_analyzer/unused_code_analyzer.dart';
import 'package:dart_code_metrics/src/analyzers/unused_code_analyzer/unused_code_config.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  group(
    'UnusedCodeAnalyzer',
    () {
      const analyzer = UnusedCodeAnalyzer();
      const rootDirectory = '';
      const analyzerExcludes = [
        'test/resources/unused_code_analyzer/generated/**',
      ];
      final folders = [
        normalize(File('test/resources/unused_code_analyzer').absolute.path),
      ];

      group('run analysis', () {
        late Iterable<UnusedCodeFileReport> result;

        setUpAll(() async {
          final config =
              _createConfig(analyzerExcludePatterns: analyzerExcludes);

          result = await analyzer.runCliAnalysis(
            folders,
            rootDirectory,
            config,
          );
        });

        test('should report 3 files and not report excluded file', () {
          expect(result.length, 3);
        });

        test('should analyze not used files', () async {
          final report = result
              .firstWhere((report) => report.path.endsWith('not_used.dart'));

          expect(report.issues.length, 3);

          final firstIssue = report.issues.first;
          expect(firstIssue.declarationName, 'NotUsed');
          expect(firstIssue.declarationType, 'class');
          expect(firstIssue.location.line, 1);
          expect(firstIssue.location.column, 1);

          final secondIssue = report.issues.elementAt(1);
          expect(secondIssue.declarationName, 'value');
          expect(secondIssue.declarationType, 'top level variable');
          expect(secondIssue.location.line, 3);
          expect(secondIssue.location.column, 1);

          final thirdIssue = report.issues.elementAt(2);
          expect(thirdIssue.declarationName, 'someFunction');
          expect(thirdIssue.declarationType, 'function');
          expect(thirdIssue.location.line, 6);
          expect(thirdIssue.location.column, 1);
        });

        test('should analyze conditional import files', () async {
          final unconditionalReport = result.firstWhereOrNull(
            (report) => report.path.endsWith('unconditional_file.dart'),
          );

          expect(unconditionalReport, null);

          final report = result.firstWhere(
            (report) => report.path.endsWith('conditional_file.dart'),
          );

          expect(report.issues.length, 1);

          final firstIssue = report.issues.first;
          expect(firstIssue.declarationName, 'hello');
          expect(firstIssue.declarationType, 'function');
          expect(firstIssue.location.line, 6);
          expect(firstIssue.location.column, 1);
        });

        test('should analyze files', () async {
          final report = result.firstWhere(
            (report) => report.path.endsWith('public_members.dart'),
          );

          expect(report.issues.length, 7);

          final firstIssue = report.issues.first;
          expect(firstIssue.declarationName, 'printInteger');
          expect(firstIssue.declarationType, 'function');
          expect(firstIssue.location.line, 4);
          expect(firstIssue.location.column, 1);

          final secondIssue = report.issues.elementAt(1);
          expect(secondIssue.declarationName, 'someVariable');
          expect(secondIssue.declarationType, 'top level variable');
          expect(secondIssue.location.line, 13);
          expect(secondIssue.location.column, 1);

          final thirdIssue = report.issues.elementAt(2);
          expect(thirdIssue.declarationName, 'SomeClassWithMethod');
          expect(thirdIssue.declarationType, 'class');
          expect(thirdIssue.location.line, 97);
          expect(thirdIssue.location.column, 1);

          final forthIssue = report.issues.elementAt(3);
          expect(forthIssue.declarationName, 'SomeOtherService');
          expect(forthIssue.declarationType, 'class');
          expect(forthIssue.location.line, 123);
          expect(forthIssue.location.column, 1);

          final fifthIssue = report.issues.elementAt(4);
          expect(fifthIssue.declarationName, 'IntX');
          expect(fifthIssue.declarationType, 'extension');
          expect(fifthIssue.location.line, 144);
          expect(fifthIssue.location.column, 1);

          final sixthIssue = report.issues.elementAt(5);
          expect(sixthIssue.declarationName, 'SomeOtherEnum');
          expect(sixthIssue.declarationType, 'enum');
          expect(sixthIssue.location.line, 153);
          expect(sixthIssue.location.column, 1);

          final seventhIssue = report.issues.elementAt(6);
          expect(seventhIssue.declarationName, 'World');
          expect(seventhIssue.declarationType, 'type alias');
          expect(seventhIssue.location.line, 162);
          expect(seventhIssue.location.column, 1);
        });
      });

      test('should return a reporter', () {
        final reporter = analyzer.getReporter(name: 'console', output: stdout);

        expect(reporter, isA<UnusedCodeConsoleReporter>());
      });
    },
    testOn: 'posix',
  );
}

UnusedCodeConfig _createConfig({
  Iterable<String> analyzerExcludePatterns = const [],
}) =>
    UnusedCodeConfig(
      excludePatterns: const [],
      analyzerExcludePatterns: analyzerExcludePatterns,
      isMonorepo: false,
    );
