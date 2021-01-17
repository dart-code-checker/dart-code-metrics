import 'package:code_checker/checker.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';

/// [FileRecord] builder
abstract class MetricsRecordsBuilder extends ChecksRecorder {
  void recordFunction(
      ScopedFunctionDeclaration declaration, FunctionRecord record);
}
