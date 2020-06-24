import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/file_record.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:path/path.dart' as p;

import 'metrics_analyzer_utils.dart';
import 'models/scoped_declaration.dart';

/// Holds analysis records in format-agnostic way
/// See [MetricsAnalysisRunner] to get analysis info
class MetricsAnalysisRecorder {
  String _fileGroupPath;
  String _relativeGroupPath;
  Map<ScopedDeclaration, FunctionRecord> _functionRecords;
  List<CodeIssue> _issues;

  final _records = <FileRecord>[];
  Iterable<FileRecord> records() => _records;

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
    _functionRecords = {};
    _issues = [];
  }

  void endRecordFile() {
    _records.add(FileRecord(
        fullPath: _fileGroupPath,
        relativePath: _relativeGroupPath,
        functions: Map.unmodifiable(
            _functionRecords.map<String, FunctionRecord>(
                (key, value) => MapEntry(getHumanReadableName(key), value))),
        issues: _issues));
    _relativeGroupPath = null;
    _fileGroupPath = null;
    _functionRecords = null;
    _issues = null;
  }

  void recordFunction(ScopedDeclaration declaration, FunctionRecord record) {
    _checkState();

    if (declaration == null) {
      throw ArgumentError.notNull('declaration');
    }

    _functionRecords[declaration] = record;
  }

  void recordIssues(Iterable<CodeIssue> issues) {
    _checkState();

    _issues.addAll(issues);
  }

  void _checkState() {
    if (_functionRecords == null) {
      throw StateError(
          'No record groups have been started. Use `startRecordFile` before record any data');
    }
  }
}
