import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../../../../reporters/models/code_climate_reporter.dart';
import '../../../metrics/metric_utils.dart';
import '../../../models/issue.dart';
import '../../../models/lint_file_report.dart';
import '../../../models/report.dart';
import '../../../models/severity.dart';
import '../../lint_report_params.dart';
import 'models/code_climate_issue.dart';
import 'models/code_climate_issue_category.dart';
import 'models/code_climate_issue_location.dart';
import 'models/code_climate_issue_severity.dart';

/// Lint Code Climate reporter.
///
/// Use it to create reports in Code Climate format.
class LintCodeClimateReporter
    extends CodeClimateReporter<LintFileReport, LintReportParams> {
  LintCodeClimateReporter(super.output, {super.gitlabCompatible});

  @override
  Future<void> report(
    Iterable<LintFileReport> records, {
    LintReportParams? additionalParams,
  }) async {
    if (records.isEmpty) {
      return;
    }

    final codeClimateRecords =
        records.map(_lintFileReportToCodeClimate).expand((r) => r);

    if (gitlabCompatible) {
      output.writeln(json.encode(codeClimateRecords.toList()));
    } else {
      for (final record in codeClimateRecords) {
        output.writeln('${json.encode(record)}\x00');
      }
    }
  }

  Iterable<CodeClimateIssue> _lintFileReportToCodeClimate(
    LintFileReport record,
  ) =>
      [
        ..._issuesToCodeClimate(
          [...record.issues, ...record.antiPatternCases],
          record.relativePath,
        ),
        ..._reportsToCodeClimate(
          [record.file, ...record.classes.values, ...record.functions.values],
          record.relativePath,
        ),
      ];

  Iterable<CodeClimateIssue> _issuesToCodeClimate(
    Iterable<Issue> issues,
    String relativePath,
  ) =>
      issues.map((issue) => CodeClimateIssue(
            checkName: issue.ruleId,
            description: issue.message,
            categories: _severityToIssueCategory[issue.severity]!,
            location: CodeClimateIssueLocation(relativePath, issue.location),
            severity: _severityToIssueSeverity[issue.severity]!,
            fingerprint: md5
                .convert(utf8.encode(
                  '${issue.ruleId} ${issue.message} $relativePath ${issue.location.text}',
                ))
                .toString(),
          ));

  Iterable<CodeClimateIssue> _reportsToCodeClimate(
    Iterable<Report?> reports,
    String relativePath,
  ) =>
      [
        for (final report in reports)
          if (report != null)
            for (final value in report.metrics)
              if (isReportLevel(value.level))
                CodeClimateIssue(
                  checkName: value.metricsId,
                  description: value.comment,
                  categories: const [CodeClimateIssueCategory.complexity],
                  location:
                      CodeClimateIssueLocation(relativePath, report.location),
                  severity: CodeClimateIssueSeverity.info,
                  fingerprint: md5
                      .convert(utf8.encode(
                        '${value.metricsId} ${value.comment} $relativePath ${report.location.text}',
                      ))
                      .toString(),
                ),
      ];
}

const _severityToIssueCategory = {
  Severity.error: [CodeClimateIssueCategory.bugRisk],
  Severity.warning: [CodeClimateIssueCategory.bugRisk],
  Severity.style: [CodeClimateIssueCategory.style],
  Severity.performance: [CodeClimateIssueCategory.performance],
  Severity.none: <CodeClimateIssueCategory>[],
};

const _severityToIssueSeverity = {
  Severity.error: CodeClimateIssueSeverity.blocker,
  Severity.warning: CodeClimateIssueSeverity.critical,
  Severity.style: CodeClimateIssueSeverity.minor,
  Severity.performance: CodeClimateIssueSeverity.major,
  Severity.none: CodeClimateIssueSeverity.info,
};
