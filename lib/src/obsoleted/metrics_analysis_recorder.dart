// ignore_for_file: comment_references, no-empty-block
import 'package:path/path.dart' as p;

import '../models/issue.dart';
import '../models/report.dart';
import '../models/scoped_class_declaration.dart';
import '../models/scoped_function_declaration.dart';
import 'metrics_records_builder.dart';
import 'metrics_records_store.dart';
import 'models/file_record.dart';
import 'models/function_record.dart';

/// Holds analysis records in format-agnostic way
/// See [MetricsAnalysisRunner] to get analysis info
class MetricsAnalysisRecorder
    implements MetricsRecordsBuilder, MetricsRecordsStore {
  String? _fileGroupPath;
  String? _relativeGroupPath;
  Map<ScopedClassDeclaration, Report>? _componentRecords;
  Map<ScopedFunctionDeclaration, FunctionRecord>? _functionRecords;
  List<Issue>? _issues;
  List<Issue>? _designIssues;

  final _records = <FileRecord>[];

  @override
  Iterable<FileRecord> records() => _records;

  @override
  MetricsRecordsStore recordFile(
    String filePath,
    String rootDirectory,
    void Function(MetricsRecordsBuilder) f,
  ) {
    _startRecordFile(filePath, rootDirectory);
    f(this);
    _endRecordFile();

    return this;
  }

  @override
  void recordClass(ScopedClassDeclaration declaration, Report record) {
    _checkState();
    _componentRecords?[declaration] = record;
  }

  @override
  void recordFunction(
    ScopedFunctionDeclaration _,
    Report __,
  ) {
    throw UnimplementedError();
  }

  @override
  void recordFunctionData(
    ScopedFunctionDeclaration declaration,
    FunctionRecord record,
  ) {
    _checkState();
    _functionRecords![declaration] = record;
  }

  @override
  void recordAntiPatternCases(Iterable<Issue> issues) {
    _checkState();

    _designIssues!.addAll(issues);
  }

  @override
  void recordIssues(Iterable<Issue> issues) {
    _checkState();

    _issues!.addAll(issues);
  }

  void _checkState() {
    if (_fileGroupPath == null) {
      throw StateError(
        'No record groups have been started. Use `startRecordFile` before record any data',
      );
    }
  }

  void _startRecordFile(String filePath, String rootDirectory) {
    _fileGroupPath = filePath;
    _relativeGroupPath = p.relative(filePath, from: rootDirectory);
    _componentRecords = {};
    _functionRecords = {};
    _issues = [];
    _designIssues = [];
  }

  void _endRecordFile() {
    _records.add(FileRecord(
      fullPath: _fileGroupPath!,
      relativePath: _relativeGroupPath!,
      classes: Map.unmodifiable(_componentRecords!
          .map<String, Report>((key, value) => MapEntry(key.name, value))),
      functions: Map.unmodifiable(_functionRecords!.map<String, FunctionRecord>(
        (key, value) => MapEntry(key.fullName, value),
      )),
      issues: _issues!,
      designIssues: _designIssues!,
    ));
    _relativeGroupPath = null;
    _fileGroupPath = null;
    _functionRecords = null;
    _issues = null;
    _designIssues = null;
  }
}
