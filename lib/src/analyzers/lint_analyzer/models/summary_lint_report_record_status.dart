/// Enum class represent of summary report.
class SummaryLintReportRecordStatus {
  /// Error.
  ///
  /// Status indicates that a record contains error information.
  /// Commonly represented by ❌ emoji
  static const error = SummaryLintReportRecordStatus._('error');

  /// Warning.
  ///
  /// Status indicates that a record requires user attention.
  /// Commonly represented by ⚠️ emoji.
  static const warning = SummaryLintReportRecordStatus._('warning');

  /// OK.
  ///
  /// Standard status for successful record.
  /// Commonly represented by ✅ emoji.
  static const ok = SummaryLintReportRecordStatus._('ok');

  /// None.
  ///
  /// Status for a record without a decision.
  static const none = SummaryLintReportRecordStatus._('none');

  static const values = [error, warning, ok, none];

  final String _value;

  const SummaryLintReportRecordStatus._(this._value);

  @override
  String toString() => _value;
}
