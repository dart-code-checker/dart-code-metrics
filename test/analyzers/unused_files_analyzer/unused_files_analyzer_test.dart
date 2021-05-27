@TestOn('vm')
import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/lint_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/unused_files_analyzer.dart';
import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/unused_files_config.dart';
import 'package:dart_code_metrics/src/config_builder/config_builder.dart';
import 'package:dart_code_metrics/src/config_builder/models/config.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  group(
    'UnusedFilesAnalyzer',
    () {
      const analyzer = UnusedFilesAnalyzer();
      const rootDirectory = '';
      final folders = [
        normalize(File('test/resources/unused_files_analyzer').absolute.path),
      ];

      test('should analyze files', () async {
        final config = _createConfig(rootDirectory);

        final result = await analyzer.runCliAnalysis(
          folders,
          rootDirectory,
          config,
        );

        final report = result.first.relativePath;

        expect(report, endsWith('unused_file.dart'));
      });
    },
    onPlatform: const <String, Skip>{
      'windows':
          Skip('the tests is intended for os with unix style filesystem'),
    },
  );
}

UnusedFilesConfig _createConfig(
  String rootDirectory, {
  Map<String, Map<String, Object>> antiPatterns = const {},
  Iterable<String> excludePatterns = const [],
  Map<String, Object> metrics = const {},
  Iterable<String> excludeForMetricsPatterns = const [],
  Map<String, Map<String, Object>> rules = const {},
}) =>
    UnusedFilesConfig(ConfigBuilder.getLintConfig(
      Config(
        antiPatterns: antiPatterns,
        excludePatterns: excludePatterns,
        metrics: metrics,
        excludeForMetricsPatterns: excludeForMetricsPatterns,
        rules: rules,
      ),
      rootDirectory,
    ).globalExcludes);

LintFileReport reportForFile(
  Iterable<LintFileReport> reports,
  String fileName,
) =>
    reports.firstWhere((report) => report.relativePath.endsWith(fileName));
