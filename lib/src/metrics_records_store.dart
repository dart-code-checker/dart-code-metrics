import 'package:dart_code_metrics/src/models/file_record.dart';
import 'package:dart_code_metrics/src/metrics_records_builder.dart';

import 'metrics_analysis_recorder.dart';

abstract class MetricsRecordsStore {
  Iterable<FileRecord> records();
  MetricsRecordsStore recordFile(String filePath, String rootDirectory,
      void Function(MetricsRecordsBuilder) f);

  factory MetricsRecordsStore.store() => MetricsAnalysisRecorder();
}
