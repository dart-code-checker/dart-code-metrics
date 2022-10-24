import '../models/summary_lint_report_record.dart';

/// Represents additional lint reporter params.
class LintReportParams {
  final bool congratulate;
  final Iterable<SummaryLintReportRecord<Object>> summary;

  const LintReportParams({required this.congratulate, required this.summary});
}
