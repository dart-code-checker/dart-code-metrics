// ignore_for_file: comment_references
import '../models/file_report.dart';
import 'metrics_analysis_recorder.dart';
import 'metrics_records_builder.dart';

@Deprecated('will be removed in 4.0')
abstract class MetricsRecordsStore {
  /// File records saved so far
  Iterable<FileReport> records();

  /// Add new file record for [filePath] using [MetricsRecordsBuilder] in [f]
  /// See [MetricsRecordsBuilder] interface on how to build new [FileRecord]
  MetricsRecordsStore recordFile(
    String filePath,
    String rootDirectory,
    void Function(MetricsRecordsBuilder) f,
  );

  factory MetricsRecordsStore.store() => MetricsAnalysisRecorder();
}
