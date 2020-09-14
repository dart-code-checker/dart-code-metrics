import 'dart:io';

import 'package:glob/glob.dart';

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
    final dartFilePaths = _folders.expand((directory) =>
        Glob('$directory**.dart')
            .listSync(root: _rootFolder, followLinks: false)
            .whereType<File>()
            .map((entity) => entity.path));

    for (final file in dartFilePaths) {
      _analyzer.runAnalysis(file, _rootFolder);
    }
  }
}
