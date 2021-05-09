import 'package:meta/meta.dart';

import '../../analyzers/lint_analyzer/constants.dart';
import '../../analyzers/lint_analyzer/metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';

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

const Iterable<DeprecatedOption> deprecatedOptions = [
  DeprecatedOption(
    supportUntilVersion: '3.3',
    deprecated: linesOfExecutableCodeKey,
    replacement: SourceLinesOfCodeMetric.metricId,
  ),
];
