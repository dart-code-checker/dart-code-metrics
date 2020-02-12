import 'package:built_collection/built_collection.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:path/path.dart' as p;

class MetricsAnalysisRecorder {
  String _fileGroupPath;
  String _relativeGroupPath;
  Map<String, FunctionRecord> _groupRecords;

  final _records = <ComponentRecord>[];
  Iterable<ComponentRecord> records() => _records;

  void startRecordFile(String filePath, String rootDirectory) {
    if (filePath == null) {
      throw ArgumentError.notNull('filePath');
    }
    if (_fileGroupPath != null) {
      throw StateError(
          "Can't start a file group while another one is started. Use `endRecordFile` to close the opened one.");
    }

    _fileGroupPath = filePath;
    _relativeGroupPath = rootDirectory != null
        ? p.relative(filePath, from: rootDirectory)
        : filePath;
    _groupRecords = {};
  }

  void endRecordFile() {
    _records.add(ComponentRecord(
        fullPath: _fileGroupPath,
        relativePath: _relativeGroupPath,
        records: BuiltMap.from(_groupRecords)));
    _relativeGroupPath = null;
    _fileGroupPath = null;
    _groupRecords = null;
  }

  void record(String recordName, FunctionRecord report) {
    if (recordName == null) {
      throw ArgumentError.notNull('recordName');
    }
    if (_groupRecords == null) {
      throw StateError(
          'No record groups have been started. Use `startRecordFile` before `record`');
    }

    _groupRecords[recordName] = report;
  }
}
