import 'package:meta/meta.dart';

import 'summary_lint_report_record_status.dart';

@immutable
class SummaryLintReportRecord<T> {
  final SummaryLintReportRecordStatus status;

  final String title;

  final T value;
  final T? violations;

  const SummaryLintReportRecord({
    this.status = SummaryLintReportRecordStatus.none,
    required this.title,
    required this.value,
    this.violations,
  });
}
