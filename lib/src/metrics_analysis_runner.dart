import 'metrics_analyzer.dart';
import 'metrics_records_store.dart';
import 'models/file_record.dart';

/// Coordinates [MetricsAnalyzer] and [MetricsRecordsStore] to collect code quality info
/// Use [ConsoleReporter], [HtmlReporter], [JsonReporter] or [CodeClimateReporter] to produce reports from collected info
class MetricsAnalysisRunner {
  final MetricsAnalyzer _analyzer;
  final MetricsRecordsStore _store;
  final Iterable<String> _folders;
  final String _rootFolder;

  MetricsAnalysisRunner(this._analyzer, this._store, this._folders,
      {String rootFolder})
      : _rootFolder = rootFolder;

  /// Get results of analysis run. Will return empty iterable if [run()] wasn't executed yet
  Iterable<FileRecord> results() => _store.records();

  /// Perform analysis of file paths passed in constructor
  void run() {
    for (final folder in _folders) {
      _analyzer.runAnalysis(folder, _rootFolder);
    }
  }
}
