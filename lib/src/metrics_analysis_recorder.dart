import 'package:dart_code_metrics/src/metrics_records_builder.dart';
import 'package:dart_code_metrics/src/metrics_records_store.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/file_record.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:path/path.dart' as p;

import 'models/component_record.dart';
import 'models/scoped_component_declaration.dart';
import 'models/scoped_function_declaration.dart';
import 'utils/metrics_analyzer_utils.dart';

/// Holds analysis records in format-agnostic way
/// See [MetricsAnalysisRunner] to get analysis info
class MetricsAnalysisRecorder
    implements MetricsRecordsBuilder, MetricsRecordsStore {
  String _fileGroupPath;
  String _relativeGroupPath;
  Map<ScopedComponentDeclaration, ComponentRecord> _componentRecords;
  Map<ScopedFunctionDeclaration, FunctionRecord> _functionRecords;
  List<CodeIssue> _issues;

  final _records = <FileRecord>[];
  @override
  Iterable<FileRecord> records() => _records;

  @override
  MetricsRecordsStore recordFile(String filePath, String rootDirectory,
      void Function(MetricsRecordsBuilder) f) {
    if (filePath == null) {
      throw ArgumentError.notNull('filePath');
    }

    if (f == null) {
      throw ArgumentError.notNull('f');
    }

    _startRecordFile(filePath, rootDirectory);
    f(this);
    _endRecordFile();

    return this;
  }

  @Deprecated('Use recordFile')
  void startRecordFile(String filePath, String rootDirectory) {
    _startRecordFile(filePath, rootDirectory);
  }

  @Deprecated('Use recordFile')
  void endRecordFile() {
    _endRecordFile();
  }

  @override
  @Deprecated('Use MetricsRecordsBuilder.recordComponent')
  void recordComponent(
      ScopedComponentDeclaration declaration, ComponentRecord record) {
    _checkState();

    if (declaration == null) {
      throw ArgumentError.notNull('declaration');
    }

    _componentRecords[declaration] = record;
  }

  @override
  @Deprecated('Use MetricsRecordsBuilder.recordFunction')
  void recordFunction(
      ScopedFunctionDeclaration declaration, FunctionRecord record) {
    _checkState();

    if (declaration == null) {
      throw ArgumentError.notNull('declaration');
    }

    _functionRecords[declaration] = record;
  }

  @override
  @Deprecated('Use MetricsRecordsBuilder.recordIssues')
  void recordIssues(Iterable<CodeIssue> issues) {
    _checkState();

    _issues.addAll(issues);
  }

  void _checkState() {
    if (_fileGroupPath == null) {
      throw StateError(
          'No record groups have been started. Use `startRecordFile` before record any data');
    }
  }

  void _startRecordFile(String filePath, String rootDirectory) {
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
    _componentRecords = {};
    _functionRecords = {};
    _issues = [];
  }

  void _endRecordFile() {
    _records.add(FileRecord(
        fullPath: _fileGroupPath,
        relativePath: _relativeGroupPath,
        components: Map.unmodifiable(
            _componentRecords.map<String, ComponentRecord>((key, value) =>
                MapEntry(getComponentHumanReadableName(key), value))),
        functions: Map.unmodifiable(
            _functionRecords.map<String, FunctionRecord>((key, value) =>
                MapEntry(getFunctionHumanReadableName(key), value))),
        issues: _issues));
    _relativeGroupPath = null;
    _fileGroupPath = null;
    _functionRecords = null;
    _issues = null;
  }
}
