// ignore_for_file: public_member_api_docs, prefer-trailing-comma, comment_references
import 'package:meta/meta.dart';

import 'metrics_analyzer.dart';
import 'metrics_records_store.dart';
import 'models/file_record.dart';

/// Coordinates [MetricsAnalyzer] and [MetricsRecordsStore] to collect code quality info
/// Use [ConsoleReporter], [HtmlReporter], [JsonReporter] or [CodeClimateReporter] to produce reports from collected info
@immutable
class MetricsAnalysisRunner {
  final MetricsAnalyzer _analyzer;
  final MetricsRecordsStore _store;
  final Iterable<String> _folders;
  final String _rootFolder;

  const MetricsAnalysisRunner(
      this._analyzer, this._store, this._folders, this._rootFolder);

  /// Get results of analysis run. Will return empty iterable if [run()] wasn't executed yet
  Iterable<FileRecord> results() => _store.records();

  /// Perform analysis of file paths passed in constructor
  Future<void> run() => _analyzer.runAnalysis(_folders, _rootFolder);
}
