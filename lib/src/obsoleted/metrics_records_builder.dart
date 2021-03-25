// ignore_for_file: comment_references
import '../models/scoped_function_declaration.dart';
import '../reports_builder.dart';
import 'models/function_record.dart';

/// [FileRecord] builder
abstract class MetricsRecordsBuilder extends ReportsBuilder {
  void recordFunctionData(
    ScopedFunctionDeclaration declaration,
    FunctionRecord record,
  );
}
