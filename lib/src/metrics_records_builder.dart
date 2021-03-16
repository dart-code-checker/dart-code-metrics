import 'package:code_checker/checker.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';

/// [FileRecord] builder
abstract class MetricsRecordsBuilder extends ReportsBuilder {
  void recordFunctionData(
      ScopedFunctionDeclaration declaration, FunctionRecord record);
}
