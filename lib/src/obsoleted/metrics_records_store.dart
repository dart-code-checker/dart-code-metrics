// ignore_for_file: public_member_api_docs
import 'metrics_analysis_recorder.dart';
import 'metrics_records_builder.dart';
import 'models/file_record.dart';

abstract class MetricsRecordsStore {
  /// File records saved so far
  Iterable<FileRecord> records();

  /// Add new file record for [filePath] using [MetricsRecordsBuilder] in [f]
  /// See [MetricsRecordsBuilder] interface on how to build new [FileRecord]
  MetricsRecordsStore recordFile(
    String filePath,
    String rootDirectory,
    void Function(MetricsRecordsBuilder) f,
  );

  factory MetricsRecordsStore.store() => MetricsAnalysisRecorder();
}
