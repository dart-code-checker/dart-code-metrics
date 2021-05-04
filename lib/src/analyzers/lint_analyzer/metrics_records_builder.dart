// ignore_for_file: comment_references
import '../models/report.dart';
import '../models/scoped_function_declaration.dart';
import 'reporters/reports_builder.dart';

/// [FileRecord] builder
@Deprecated('will be removed in 3.3')
abstract class MetricsRecordsBuilder extends ReportsBuilder {
  void recordFunctionData(ScopedFunctionDeclaration declaration, Report record);
}
