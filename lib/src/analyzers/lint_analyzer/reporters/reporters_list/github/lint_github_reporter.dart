import 'dart:io';

import '../../../../../reporters/models/github_reporter.dart';
import '../../../models/lint_file_report.dart';
import '../../../models/severity.dart';
import '../../../models/summary_lint_report_record.dart';
import '../../lint_report_params.dart';

const _deprecationMessage =
    'DEPRECATED! This reporter is deprecated and will be removed in 5.0.0. You can migrate on our GitHub Action.';

/// Lint GitHub reporter.
///
/// Use it to create reports in GitHub format.
///
/// **Note:** this reporter is deprecated and should not be used.
/// Consider using Dart Code Metrics GitHub Action instead.
class LintGitHubReporter extends GitHubReporter<LintFileReport,
    SummaryLintReportRecord<Object>, LintReportParams> {
  const LintGitHubReporter(IOSink output) : super(output);

  @override
  Future<void> report(
    Iterable<LintFileReport> records, {
    Iterable<SummaryLintReportRecord<Object>> summary = const [],
    LintReportParams? additionalParams,
  }) async {
    if (records.isEmpty) {
      return;
    }

    for (final analysisRecord in records) {
      for (final antiPattern in analysisRecord.antiPatternCases) {
        output.writeln(GitHubReporter.commands.warning(
          '$_deprecationMessage ${antiPattern.message}',
          absolutePath: analysisRecord.path,
          sourceSpan: antiPattern.location,
        ));
      }

      for (final issue in analysisRecord.issues) {
        output.writeln(
          issue.severity == Severity.error
              ? GitHubReporter.commands.error(
                  '$_deprecationMessage ${issue.message}',
                  absolutePath: analysisRecord.path,
                  sourceSpan: issue.location,
                )
              : GitHubReporter.commands.warning(
                  '$_deprecationMessage ${issue.message}',
                  absolutePath: analysisRecord.path,
                  sourceSpan: issue.location,
                ),
        );
      }
    }
  }
}
