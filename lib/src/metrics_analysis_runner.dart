import 'package:dart_code_metrics/src/metrics_analysis_recorder.dart';
import 'package:dart_code_metrics/src/metrics_analyzer.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';

class MetricsAnalysisRunner {
  final MetricsAnalysisRecorder _recorder;
  final MetricsAnalyzer _analyzer;
  final Iterable<String> _filePaths;
  final String _rootFolder;

  MetricsAnalysisRunner(this._recorder, this._analyzer, this._filePaths, {String rootFolder})
      : _rootFolder = rootFolder;

  Iterable<ComponentRecord> results() => _recorder.records();

  void run() {
    for (final file in _filePaths) {
      _analyzer.runAnalysis(file, _rootFolder);
    }
  }
}
