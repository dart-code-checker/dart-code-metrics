import 'package:ansicolor/ansicolor.dart';

import '../../../../../utils/string_extension.dart';
import '../../../metrics/models/metric_value.dart';
import '../../../metrics/models/metric_value_level.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';

class LintConsoleReporterHelper {
  static final _colorPens = {
    MetricValueLevel.alarm: AnsiPen()..red(),
    MetricValueLevel.warning: AnsiPen()..yellow(),
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

  String getIssueMessage(Issue issue) {
    final severity = _getSeverity(issue.severity);
    final location =
        '${issue.location.start.line}:${issue.location.start.column}';

    return '$severity${[issue.message, location, issue.ruleId].join(' : ')}';
  }

  String getMetricMessage(
    MetricValueLevel violationLevel,
    String source,
    Iterable<String> violations,
  ) {
    final color = _colorPens[violationLevel];
    if (color != null) {
      final normalizedLabel = _normalize(
        violationLevel != MetricValueLevel.none
            ? violationLevel.toString().capitalize()
            : '',
      );

      return '${color(normalizedLabel)}$source - ${violations.join(', ')}';
    }

    throw StateError('Unexpected violation level.');
  }

  String getMetricReport(MetricValue<num> metric) {
    final color = _colorPens[metric.level];

    if (color != null) {
      final value = metric.value.toInt();

      return '${metric.documentation.name.toLowerCase()}: ${color('$value')}';
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
