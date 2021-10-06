import 'package:collection/collection.dart';

import '../metrics/models/metric_value_level.dart';
import '../models/lint_file_report.dart';
import '../models/severity.dart';

MetricValueLevel maxMetricViolationLevel(Iterable<LintFileReport> records) =>
    records
        .expand(
          (record) => [...record.classes.values, ...record.functions.values]
              .map((report) => report.metricsLevel),
        )
        .max;

bool hasIssueWithSevetiry(
  Iterable<LintFileReport> records,
  Severity severity,
) =>
    records.any((record) =>
        record.issues.any((issue) => issue.severity == severity) ||
        record.antiPatternCases.any((issue) => issue.severity == severity));
