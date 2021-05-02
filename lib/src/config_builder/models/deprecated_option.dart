import 'package:meta/meta.dart';

/// Class representing deprecated config option
@immutable
class DeprecatedOption {
  /// The last version number which supports the option.
  final String supportUntilVersion;

  /// Deprecated option name.
  final String deprecated;

  /// New option name (optional).
  final String? replacement;

  const DeprecatedOption({
    required this.supportUntilVersion,
    required this.deprecated,
    this.replacement,
  });
}

const Iterable<DeprecatedOption> deprecatedOptions = [];
