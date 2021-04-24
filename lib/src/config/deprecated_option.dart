import 'package:meta/meta.dart';

/// Class representing deprecated config option
@immutable
class DeprecatedOption {
  /// Version number until which we support obsolete option
  final String supportUntilVersion;

  /// Obsolete option name
  final String deprecated;

  /// Modern option name (optional)
  final String? modern;

  const DeprecatedOption({
    required this.supportUntilVersion,
    required this.deprecated,
    this.modern,
  });
}

const Iterable<DeprecatedOption> deprecatedOptions = [];
