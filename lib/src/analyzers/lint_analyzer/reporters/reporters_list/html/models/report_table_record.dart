import 'file_metrics_report.dart';

/// A table record
///
/// used by html reporter to represent file system entiry with accomulated metrics
class ReportTableRecord {
  final String title;
  final String link;

  final FileMetricsReport report;

  const ReportTableRecord({
    required this.title,
    required this.link,
    required this.report,
  });
}
