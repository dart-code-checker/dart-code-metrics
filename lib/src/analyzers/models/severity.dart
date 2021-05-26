/// Enum class for severity.
///
/// Used when reporting issues.
class Severity {
  /// Programming error.
  ///
  /// Indicates a severe issue like a memory leak, etc.
  static const error = Severity._('error');

  /// Warning.
  ///
  /// Indicates a dangerous coding style that can cause severe runtime errors.
  /// For example: accessing an out of range array element.
  static const warning = Severity._('warning');

  /// Performance warning.
  ///
  /// Indicates a suboptimal code, fixing it will lead to a better performance.
  static const performance = Severity._('performance');

  /// Style warning.
  ///
  /// Used for general code cleanup recommendations. Fixing these will not fix
  /// any bugs but will make the code easier to maintain.
  /// For example: trailing comma, blank line before return, etc...
  static const style = Severity._('style');

  /// No severity.
  ///
  /// Default value.
  static const none = Severity._('none');

  /// A list containing all of the enum values that are defined.
  static const values = [error, warning, performance, style, none];

  final String _value;

  const Severity._(this._value);

  /// Converts the human readable [severity] string into a [Severity] value.
  static Severity? fromString(String? severity) => severity != null
      ? values.firstWhere(
          (value) => value._value == severity.toLowerCase(),
          orElse: () => Severity.none,
        )
      : null;

  @override
  String toString() => _value;
}
