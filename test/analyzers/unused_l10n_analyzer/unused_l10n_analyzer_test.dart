@TestOn('vm')
import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/unused_l10n_analyzer/reporters/reporters_list/console/unused_l10n_console_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/unused_l10n_analyzer/unused_l10n_analyzer.dart';
import 'package:dart_code_metrics/src/analyzers/unused_l10n_analyzer/unused_l10n_config.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  group(
    'UnusedL10nAnalyzer',
    () {
      const analyzer = UnusedL10nAnalyzer();
      const rootDirectory = '';
      const analyzerExcludes = <String>[
        'test/resources/**',
        'test/resources/unused_files_analyzer/generated/**/**',
        'test/**/examples/**',
      ];
      final folders = [
        normalize(
          File('test/resources/unused_l10n_analyzer').absolute.path,
        ),
      ];

      test('should analyze files', () async {
        final config = _createConfig(analyzerExcludePatterns: analyzerExcludes);

        final result = await analyzer.runCliAnalysis(
          folders,
          rootDirectory,
          config,
        );

        final report = result.single;
        final issue = report.issues.single;

        expect(report.className, 'TestI18n');
        expect(issue.memberName, 'getter');
        expect(issue.location.line, 4);
        expect(issue.location.column, 3);
      });

      test('should report no issues for a custom class name pattern', () async {
        final config = _createConfig(
          analyzerExcludePatterns: analyzerExcludes,
          classPattern: 'SomeClass',
        );

        final result = await analyzer.runCliAnalysis(
          folders,
          rootDirectory,
          config,
        );

        expect(result, isEmpty);
      });

      test('should return a reporter', () {
        final reporter = analyzer.getReporter(name: 'console', output: stdout);

        expect(reporter, isA<UnusedL10nConsoleReporter>());
      });
    },
    testOn: 'posix',
  );
}

UnusedL10nConfig _createConfig({
  Iterable<String> analyzerExcludePatterns = const [],
  String classPattern = r'I18n$',
}) =>
    UnusedL10nConfig(
      excludePatterns: const [],
      analyzerExcludePatterns: analyzerExcludePatterns,
      classPattern: classPattern,
    );
