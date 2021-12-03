import 'package:ansicolor/ansicolor.dart';

import '../../../../../utils/string_extensions.dart';
import '../../../metrics/models/metric_value.dart';
import '../../../metrics/models/metric_value_level.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';

/// Helper for building lint console reports
class LintConsoleReporterHelper {
  static final _colorPens = {
    MetricValueLevel.alarm: AnsiPen()..red(bold: true),
    MetricValueLevel.warning: AnsiPen()..yellow(bold: true),
    MetricValueLevel.noted: AnsiPen()..blue(),
    MetricValueLevel.none: AnsiPen()..white(),
  };

  final _severityPens = {
    Severity.error: AnsiPen()..red(bold: true),
    Severity.warning: AnsiPen()..yellow(bold: true),
    Severity.performance: AnsiPen()..cyan(),
    Severity.style: AnsiPen()..blue(),
    Severity.none: AnsiPen()..white(),
  };

  /// Converts an [issue] to the issue message string.
  String getIssueMessage(Issue issue) {
    final severity = _getSeverity(issue.severity);
    final location =
        '${issue.location.start.line}:${issue.location.start.column}';

    return '$severity${[issue.message, location, issue.ruleId].join(' : ')}';
  }

  /// Creates a message for [violations] based on given [violationLevel].
  String getMetricMessage(
    MetricValueLevel violationLevel,
    String source,
    Iterable<String> violations,
  ) {
    final color = _colorPens[violationLevel];
    if (color != null) {
      final normalizedLabel = color(_normalize(
        violationLevel != MetricValueLevel.none
            ? violationLevel.toString().capitalize()
            : '',
      ));

      return '$normalizedLabel${source.isNotEmpty ? '$source - ' : ''}${violations.join(', ')}';
    }

    throw StateError('Unexpected violation level.');
  }

  /// Converts a [metric] to the metric message string.
  String getMetricReport(MetricValue<num> metric) {
    final color = _colorPens[metric.level];

    if (color != null) {
      final value = '${metric.value.toInt()} ${metric.unitType ?? ''}'.trim();

      return '${metric.documentation.name.toLowerCase()}: ${color(value)}';
    }

    throw StateError('Unexpected violation level.');
  }

  String _getSeverity(Severity severity) {
    final color = _severityPens[severity];

    if (color != null) {
      return color(_normalize(
        severity != Severity.none ? severity.toString().capitalize() : '',
      ));
    }

    throw StateError('Unexpected severity.');
  }

  String _normalize(String s) => s.padRight(8);
}
