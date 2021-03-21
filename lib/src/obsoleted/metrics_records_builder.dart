// ignore_for_file: public_member_api_docs, comment_references
import 'package:code_checker/checker.dart';

import 'models/function_record.dart';

/// [FileRecord] builder
abstract class MetricsRecordsBuilder extends ReportsBuilder {
  void recordFunctionData(
    ScopedFunctionDeclaration declaration,
    FunctionRecord record,
  );
}
