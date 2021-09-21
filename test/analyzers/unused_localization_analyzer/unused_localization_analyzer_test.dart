@TestOn('vm')
import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/reporters/reporters_list/console/unused_files_console_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/unused_localization_analyzer/reporters/reporters_list/console/unused_localization_console_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/unused_localization_analyzer/unused_localization_analyzer.dart';
import 'package:dart_code_metrics/src/analyzers/unused_localization_analyzer/unused_localization_config.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  group(
    'UnusedLocalizationAnalyzer',
    () {
      const analyzer = UnusedLocalizationAnalyzer();
      const rootDirectory = '';
      const analyzerExcludes = <String>[
        'test/resources/**',
        'test/resources/unused_files_analyzer/generated/**/**',
        'test/**/examples/**',
      ];
      final folders = [
        normalize(
          File('test/resources/unused_localization_analyzer').absolute.path,
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

        expect(report.className, 'TestI18n');
        expect(report.unusedMembersLocation, hasLength(1));
      });

      test('should return a reporter', () {
        final reporter = analyzer.getReporter(name: 'console', output: stdout);

        expect(reporter, isA<UnusedLocalizationConsoleReporter>());
      });
    },
    testOn: 'posix',
  );
}

UnusedLocalizationConfig _createConfig({
  Iterable<String> analyzerExcludePatterns = const [],
  String classPattern = r'I18n$',
}) =>
    UnusedLocalizationConfig(
      excludePatterns: const [],
      analyzerExcludePatterns: analyzerExcludePatterns,
      classPattern: classPattern,
    );
