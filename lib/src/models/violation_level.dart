class ViolationLevel implements Comparable<ViolationLevel> {
  static const ViolationLevel none = ViolationLevel._('None');
  static const ViolationLevel noted = ViolationLevel._('Noted');
  static const ViolationLevel warning = ViolationLevel._('Warning');
  static const ViolationLevel alarm = ViolationLevel._('Alarm');

  static const Iterable<ViolationLevel> values = [
    ViolationLevel.none,
    ViolationLevel.noted,
    ViolationLevel.warning,
    ViolationLevel.alarm
  ];

  final String _name;

  factory ViolationLevel.fromString(String s) =>
      values.firstWhere((v) => v.toString().toLowerCase() == s?.toLowerCase(),
          orElse: () => null);

  const ViolationLevel._(this._name);

  @override
  String toString() => _name;

  @override
  int compareTo(ViolationLevel other) {
    final valuesList = values.toList(growable: false);

    return valuesList.indexOf(this).compareTo(valuesList.indexOf(other));
  }

  bool operator >(ViolationLevel other) => compareTo(other) > 0;
  bool operator >=(ViolationLevel other) => compareTo(other) >= 0;
  bool operator <(ViolationLevel other) => compareTo(other) < 0;
  bool operator <=(ViolationLevel other) => compareTo(other) <= 0;
}
