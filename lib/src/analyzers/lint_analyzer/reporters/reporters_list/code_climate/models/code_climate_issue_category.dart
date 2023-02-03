// ignore_for_file: unused-code

/// Represents a Code Climate issue category.
class CodeClimateIssueCategory {
  static const bugRisk = CodeClimateIssueCategory._('Bug Risk');
  static const clarity = CodeClimateIssueCategory._('Clarity');
  static const compatibility = CodeClimateIssueCategory._('Compatibility');
  static const complexity = CodeClimateIssueCategory._('Complexity');
  static const duplication = CodeClimateIssueCategory._('Duplication');
  static const performance = CodeClimateIssueCategory._('Performance');
  static const security = CodeClimateIssueCategory._('Security');
  static const style = CodeClimateIssueCategory._('Style');

  final String _value;

  const CodeClimateIssueCategory._(this._value);

  @override
  String toString() => _value;
}
