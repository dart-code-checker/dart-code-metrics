@TestOn('vm')
import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/lint_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/reporters/reporters_list/console/unused_files_console_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/unused_files_analyzer.dart';
import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/unused_files_config.dart';
import 'package:dart_code_metrics/src/config_builder/config_builder.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  group(
    'UnusedFilesAnalyzer',
    () {
      const analyzer = UnusedFilesAnalyzer();
      const rootDirectory = '';
      const analyzerExcludes = [
        'test/resources/**',
        'test/resources/unused_files_analyzer/generated/**/**',
        'test/**/examples/**',
      ];
      final folders = [
        normalize(File('test/resources/unused_files_analyzer').absolute.path),
      ];

      test('should analyze files', () async {
        final config = _createConfig(rootDirectory);

        final result = await analyzer.runCliAnalysis(
          folders,
          rootDirectory,
          config,
          analyzerExcludes,
        );

        final report = result.single.relativePath;

        expect(report, endsWith('unused_file.dart'));
      });

      test('should return a reporter', () {
        final reporter = analyzer.getReporter(name: 'console', output: stdout);

        expect(reporter, isA<UnusedFilesConsoleReporter>());
      });
    },
    testOn: 'posix',
  );
}

UnusedFilesConfig _createConfig(
  String rootDirectory, {
  Iterable<String> excludePatterns = const [],
}) =>
    ConfigBuilder.getUnusedFilesConfig(rootDirectory, excludePatterns);

LintFileReport reportForFile(
  Iterable<LintFileReport> reports,
  String fileName,
) =>
    reports.firstWhere((report) => report.relativePath.endsWith(fileName));
