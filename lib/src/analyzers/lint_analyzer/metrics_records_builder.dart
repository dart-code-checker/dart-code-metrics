// ignore_for_file: comment_references
import '../models/report.dart';
import '../models/scoped_function_declaration.dart';
import 'reporters/reports_builder.dart';

/// [FileRecord] builder
abstract class MetricsRecordsBuilder extends ReportsBuilder {
  void recordFunctionData(ScopedFunctionDeclaration declaration, Report record);
}
