import 'package:dart_code_metrics/src/metrics_analysis_recorder.dart';
import 'package:dart_code_metrics/src/metrics_analyzer.dart';
import 'package:dart_code_metrics/src/models/file_record.dart';

/// Coordinates [MetricsAnalysisRecorder] and [MetricsAnalyzer] to collect code quality info
/// Use [ConsoleReporter], [HtmlReporter], [JsonReporter] or [CodeClimateReporter] to produce reports from collected info
class MetricsAnalysisRunner {
  final MetricsAnalysisRecorder _recorder;
  final MetricsAnalyzer _analyzer;
  final Iterable<String> _filePaths;
  final String _rootFolder;

  MetricsAnalysisRunner(this._recorder, this._analyzer, this._filePaths,
      {String rootFolder})
      : _rootFolder = rootFolder;

  /// Get results of analysis run. Will return empty iterable if [run()] wasn't executed yet
  Iterable<FileRecord> results() => _recorder.records();

  /// Perform analysis of file paths passed in constructor
  void run() {
    for (final file in _filePaths) {
      _analyzer.runAnalysis(file, _rootFolder);
    }
  }
}
