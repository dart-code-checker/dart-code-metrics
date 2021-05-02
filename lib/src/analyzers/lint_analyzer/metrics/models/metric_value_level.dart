/// Enum class for value level.
///
/// Used when reporting computed metric value.
class MetricValueLevel implements Comparable<MetricValueLevel> {
  /// The value in the "green" zone.
  ///
  /// Default value.
  static const none = MetricValueLevel._('none');

  /// The value in the "blue" zone.
  ///
  /// The value in the 80% - 100% range of the threshold.
  static const noted = MetricValueLevel._('noted');

  /// The value in the "yellow" zone.
  ///
  /// The value in the 100% - 200% range of the threshold.
  static const warning = MetricValueLevel._('warning');

  /// The value in the "red" zone.
  ///
  /// The value is greater than the 200% of the threshold.
  static const alarm = MetricValueLevel._('alarm');

  /// A list containing all of the enum values that are defined.
  static const values = [
    MetricValueLevel.none,
    MetricValueLevel.noted,
    MetricValueLevel.warning,
    MetricValueLevel.alarm,
  ];

  final String _name;

  /// Converts the human readable [level] string into a [MetricValueLevel] value.
  static MetricValueLevel? fromString(String? level) => level != null
      ? values.firstWhere(
          (val) => val._name == level.toLowerCase(),
          orElse: () => MetricValueLevel.none,
        )
      : null;

  const MetricValueLevel._(this._name);

  @override
  String toString() => _name;

  @override
  int compareTo(MetricValueLevel other) =>
      values.indexOf(this).compareTo(values.indexOf(other));

  /// Relational less than operator.
  bool operator <(MetricValueLevel other) => compareTo(other) < 0;

  /// Relational less than or equal operator.
  bool operator <=(MetricValueLevel other) => compareTo(other) <= 0;

  /// Relational greater than operator.
  bool operator >(MetricValueLevel other) => compareTo(other) > 0;

  /// Relational greater than or equal operator.
  bool operator >=(MetricValueLevel other) => compareTo(other) >= 0;
}
