import 'metrics_analysis_recorder.dart';
import 'metrics_records_builder.dart';
import 'models/file_record.dart';

abstract class MetricsRecordsStore {
  Iterable<FileRecord> records();
  MetricsRecordsStore recordFile(String filePath, String rootDirectory,
      void Function(MetricsRecordsBuilder) f);

  factory MetricsRecordsStore.store() => MetricsAnalysisRecorder();
}
