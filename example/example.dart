import 'package:dart_code_metrics/metrics_analyzer.dart';
import 'package:dart_code_metrics/reporters.dart';

void main() {
  // Get some files you would like to analyze
  final filesToAnalyze = ['some_file.dart', 'another_file.dart'];
  // Root folder path is used to resolve relative file paths
  final rootFolder = 'lib/src';

  // Recorder keeps reported issues in format-agnostic way
  final recorder = MetricsAnalysisRecorder();

  // Analyzer traverses files and report its findings to passed recorder
  final analyzer = MetricsAnalyzer(recorder);

  // Runner coordinates recorder and analyzer
  final runner = MetricsAnalysisRunner(recorder, analyzer, filesToAnalyze,
      rootFolder: rootFolder);

  // Execute run() to analyze files and collect results
  runner.run();

  // Now runner.results() contains some insights about analyzed code. Let's report it!
  // For a simple example we would report results to terminal

  // First of all config has to be created for a reporter
  final reporterConfig =
      Config(cyclomaticComplexityWarningLevel: 10, linesOfCodeWarningLevel: 50);

  // Now the reporter itself
  final reporter = ConsoleReporter(reportConfig: reporterConfig);

  // Now pass collected analysis reports from runner to reporter and that's it
  reporter.report(runner.results()).forEach(print);

  // There is also JsonReporter for making machine-readable reports
  // HtmlReporter produces fancy html-documents with bells and whistles
  // And CodeClimateReporter produces reports that are widely understood by various CI tools
  // If none of these fits your case you can always access raw analysis info via results() method of runner and process it any way you see fit
}
