import 'package:ansicolor/ansicolor.dart';

import '../../../metrics/models/metric_value.dart';
import '../../../metrics/models/metric_value_level.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';

final _alarmPen = AnsiPen()..rgb(r: 0.88, g: 0.32, b: 0.36);
final _warningPen = AnsiPen()..rgb(r: 0.98, g: 0.68, b: 0.4);
final _bluePen = AnsiPen()..rgb(r: 0.08, g: 0.11, b: 0.81);
final _whitePen = AnsiPen()..white();

final _linkPen = AnsiPen()..rgb(r: 0.0, g: 0.78, b: 1.0);

/// Helper for building lint console reports.
class LintConsoleReporterHelper {
  static final _colorPens = {
    MetricValueLevel.alarm: _alarmPen,
    MetricValueLevel.warning: _warningPen,
    MetricValueLevel.noted: _bluePen,
    MetricValueLevel.none: _whitePen,
  };

  final _severityPens = {
    Severity.error: _alarmPen,
    Severity.warning: _warningPen,
    Severity.performance: _bluePen,
    Severity.style: _bluePen,
    Severity.none: _whitePen,
  };

  /// Converts an [issue] to the issue message string.
  Iterable<String> getIssueMessage(Issue issue, String absolutePath) {
    final severity = _getSeverity(issue.severity);
    final locationStart = issue.location.start;
    final location = _linkPen(
      '$absolutePath:${locationStart.line}:${locationStart.column}',
    );
    final tabulation = _normalize('');

    return [
      '$severity${issue.message}',
      '${tabulation}at $location',
      '$tabulation${issue.ruleId} : ${issue.documentation}',
      '',
    ];
  }

  /// Creates a message for [violations] based on given [violationLevel].
  Iterable<String> getMetricMessage(
    MetricValueLevel violationLevel,
    String source,
    Iterable<String> violations,
  ) {
    if (violations.isEmpty) {
      return [];
    }

    final color = _colorPens[violationLevel];
    if (color != null) {
      final normalizedLabel =
          color(_normalize(violationLevel.toString().toUpperCase()));

      final firstLine = source.isNotEmpty ? source : violations.first;
      final records = source.isNotEmpty ? violations : violations.skip(1);
      final tabulation = _normalize('');

      return [
        '$normalizedLabel$firstLine',
        for (final record in records) '$tabulation$record',
        '',
      ];
    }

    throw StateError('Unexpected violation level.');
  }

  /// Converts a [metric] to the metric message string.
  String getMetricReport(MetricValue metric) {
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
        severity != Severity.none ? severity.toString().toUpperCase() : '',
      ));
    }

    throw StateError('Unexpected severity.');
  }

  String _normalize(String s) => s.padRight(8);
}
