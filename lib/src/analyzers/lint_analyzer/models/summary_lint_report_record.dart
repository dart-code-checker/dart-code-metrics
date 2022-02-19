import 'summary_lint_report_record_status.dart';

/// Represents a summary for a lint report.
class SummaryLintReportRecord<T extends Object> {
  final SummaryLintReportRecordStatus status;

  final String title;

  final T value;
  final int violations;

  const SummaryLintReportRecord({
    this.status = SummaryLintReportRecordStatus.none,
    required this.title,
    required this.value,
    this.violations = 0,
  });
}
