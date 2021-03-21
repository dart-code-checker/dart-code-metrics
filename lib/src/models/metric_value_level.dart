/// Enum class for value level.
/// 
/// Used when reporting computed metric value.
class MetricValueLevel implements Comparable<MetricValueLevel> {
  /// Value in "green" zone
  ///
  /// Default value
  static const MetricValueLevel none = MetricValueLevel._('none');

  /// Value in "blue" zone
  ///
  /// Value in range 80% - 100% of the threshold
  static const MetricValueLevel noted = MetricValueLevel._('noted');

  /// Value in "yellow" zone
  ///
  /// Value in range 100% - 200% of the threshold
  static const MetricValueLevel warning = MetricValueLevel._('warning');

  /// Value in "red" zone
  ///
  /// Value greater than 200% of the threshold
  static const MetricValueLevel alarm = MetricValueLevel._('alarm');

  /// A list containing all of the enum values that are defined.
  static const values = [
    MetricValueLevel.none,
    MetricValueLevel.noted,
    MetricValueLevel.warning,
    MetricValueLevel.alarm,
  ];

  final String _name;

  /// Converts the human readable [level] string into a [MetricValueLevel] value
  static MetricValueLevel fromString(String level) => level != null
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

  /// Relational less than operator
  bool operator <(MetricValueLevel other) => compareTo(other) < 0;

  /// Relational less than or equal operator
  bool operator <=(MetricValueLevel other) => compareTo(other) <= 0;

  /// Relational greater than operator
  bool operator >(MetricValueLevel other) => compareTo(other) > 0;

  /// Relational greater than or equal operator
  bool operator >=(MetricValueLevel other) => compareTo(other) >= 0;
}
