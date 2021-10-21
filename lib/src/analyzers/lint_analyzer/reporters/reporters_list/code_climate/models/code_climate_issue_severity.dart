/// Represents a Code Climate issue severity.
class CodeClimateIssueSeverity {
  static const blocker = CodeClimateIssueSeverity._('blocker');
  static const critical = CodeClimateIssueSeverity._('critical');
  static const major = CodeClimateIssueSeverity._('major');
  static const minor = CodeClimateIssueSeverity._('minor');
  static const info = CodeClimateIssueSeverity._('info');

  final String _value;

  const CodeClimateIssueSeverity._(this._value);

  @override
  String toString() => _value;
}
