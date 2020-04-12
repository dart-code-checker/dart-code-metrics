import 'package:meta/meta.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';

@immutable
class ComponentRecord {
  final String fullPath;
  final String relativePath;

  final Map<String, FunctionRecord> records;

  const ComponentRecord(
      {@required this.fullPath,
      @required this.relativePath,
      @required this.records});
}
