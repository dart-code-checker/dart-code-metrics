import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:path/path.dart' as p;

/// Holds analysis records in format-agnostic way
/// See [MetricsAnalysisRunner] to get analysis info
class MetricsAnalysisRecorder {
  String _fileGroupPath;
  String _relativeGroupPath;
  Map<String, FunctionRecord> _groupRecords;
  List<CodeIssue> _issues;

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
    _issues = [];
  }

  void endRecordFile() {
    _records.add(ComponentRecord(
        fullPath: _fileGroupPath,
        relativePath: _relativeGroupPath,
        records: Map.unmodifiable(_groupRecords),
        issues: _issues));
    _relativeGroupPath = null;
    _fileGroupPath = null;
    _groupRecords = null;
    _issues = null;
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
