import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;

import '../metrics/metric_utils.dart';
import '../metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import '../metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
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

Iterable<String> scannedFolders(Iterable<LintFileReport> records) =>
    records.map((record) => p.split(record.relativePath).first).toSet().toList()
      ..sort();

int totalFiles(Iterable<LintFileReport> records) =>
    records.map((record) => record.path).toSet().length;

int totalSLOC(Iterable<LintFileReport> records) => records.fold(
      0,
      (prevValue, fileReport) =>
          prevValue +
          fileReport.functions.values.fold(
            0,
            (prevValue, functionReport) =>
                prevValue +
                (functionReport
                        .metric(SourceLinesOfCodeMetric.metricId)
                        ?.value
                        .toInt() ??
                    0),
          ),
    );

int totalClasses(Iterable<LintFileReport> records) => records.fold(
      0,
      (prevValue, fileReport) => prevValue + fileReport.classes.keys.length,
    );

double averageCYCLO(Iterable<LintFileReport> records) =>
    records.fold<num>(
      0,
      (prevValue, fileReport) =>
          prevValue +
          fileReport.functions.values.fold(
            0,
            (prevValue, functionReport) =>
                prevValue +
                (functionReport
                        .metric(CyclomaticComplexityMetric.metricId)
                        ?.value ??
                    0),
          ),
    ) /
    totalSLOC(records);

int averageSLOC(Iterable<LintFileReport> records) {
  final functionsCount = records.fold<int>(
    0,
    (prevValue, fileReport) => prevValue + fileReport.functions.keys.length,
  );

  return functionsCount > 0 ? totalSLOC(records) ~/ functionsCount : 0;
}

int metricOverflows(Iterable<LintFileReport> records, String metricId) =>
    records.fold<int>(
      0,
      (prevValue, fileReport) =>
          prevValue +
          fileReport.functions.values.fold(
            0,
            (prevValue, functionReport) =>
                prevValue +
                (isReportLevel(functionReport.metric(metricId)?.level ??
                        MetricValueLevel.none)
                    ? 1
                    : 0),
          ),
    );
