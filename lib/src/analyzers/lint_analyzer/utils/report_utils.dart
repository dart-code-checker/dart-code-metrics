import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;

import '../metrics/metric_utils.dart';
import '../metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import '../metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import '../metrics/metrics_list/technical_debt/technical_debt_metric.dart';
import '../metrics/models/metric_value_level.dart';
import '../models/lint_file_report.dart';
import '../models/severity.dart';

MetricValueLevel maxMetricViolationLevel(Iterable<LintFileReport> records) =>
    records
        .expand(
          (record) => [...record.classes.values, ...record.functions.values]
              .map((report) => report.metricsLevel),
        )
        .maxOrNull ??
    MetricValueLevel.none;

bool hasIssueWithSeverity(
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

String totalTechDebt(Iterable<LintFileReport> records) {
  final debtValue = records.fold<num>(
    0,
    (prevValue, fileReport) =>
        prevValue +
        (fileReport.file?.metric(TechnicalDebtMetric.metricId)?.value ?? 0),
  );

  final debtUnitType = records
          .firstWhereOrNull(
            (record) =>
                record.file?.metric(TechnicalDebtMetric.metricId) != null,
          )
          ?.file
          ?.metric(TechnicalDebtMetric.metricId)
          ?.unitType ??
      '';

  return debtValue > 0 ? '$debtValue $debtUnitType'.trim() : 'not found';
}

int totalClasses(Iterable<LintFileReport> records) => records.fold(
      0,
      (prevValue, fileReport) => prevValue + fileReport.classes.keys.length,
    );

double averageCYCLO(Iterable<LintFileReport> records) {
  final totalSloc = totalSLOC(records);

  return totalSloc > 0
      ? records.fold<num>(
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
          totalSloc
      : 0;
}

int averageSLOC(Iterable<LintFileReport> records) {
  final functionsCount = records.fold<int>(
    0,
    (prevValue, fileReport) => prevValue + fileReport.functions.keys.length,
  );

  return functionsCount > 0 ? totalSLOC(records) ~/ functionsCount : 0;
}

int metricViolations(Iterable<LintFileReport> records, String metricId) =>
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
