import 'dart:io';

import 'package:dart_code_metrics/metrics_analyzer.dart';
import 'package:dart_code_metrics/reporters.dart';

Future<void> main() async {
  // Get some folder you would like to analyze
  const foldersToAnalyze = ['lib', 'test'];

  // Root folder path is used to resolve relative file paths
  const rootFolder = 'projectRoot';

  // First of all config has to be created for a checker
  const config = Config(
    excludePatterns: ['test/resources/**'],
    excludeForMetricsPatterns: ['test/**'],
    metrics: {
      'maximum-nesting-level': '5',
      'number-of-methods': '10',
    },
    rules: {
      'double-literal-format': {},
      'newline-before-return': {'severity': 'info'},
    },
    antiPatterns: {'long-method': {}},
  );

  // Store keeps reported issues in format-agnostic way
  final store = MetricsRecordsStore.store();

  // Analyzer traverses files and report its findings to passed store
  final analyzer = MetricsAnalyzer(store, config);

  // Runner coordinates analyzer and store
  final runner = MetricsAnalysisRunner(
    analyzer,
    store,
    foldersToAnalyze,
    rootFolder,
  );

  // Execute run() to analyze files and collect results
  await runner.run();

  // Now runner.results() contains some insights about analyzed code. Let's report it!
  // For a simple example we would report results to terminal

  // Now the reporter itself
  final reporter = ConsoleReporter(stdout);

  // Now pass collected analysis reports from runner to reporter and that's it
  await reporter.report(runner.results());

  // There is also JsonReporter for making machine-readable reports
  // HtmlReporter produces fancy html-documents with bells and whistles
  // And CodeClimateReporter produces reports that are widely understood by various CI tools
  // If none of these fits your case you can always access raw analysis info via results() method of runner and process it any way you see fit
}
