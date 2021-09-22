import 'dart:io';

import '../../../../../reporters/models/github_reporter.dart';
import '../../../models/lint_report.dart';
import '../../../models/severity.dart';

const _deprecationMessage =
    'DEPRECATED! This reporter is deprecated and will be removed in 5.0.0. You can migrate on our GitHub Action.';

class LintGitHubReporter extends GitHubReporter<LintReport> {
  const LintGitHubReporter(IOSink output) : super(output);

  @override
  Future<void> report(LintReport report) async {
    if (report.files.isEmpty) {
      return;
    }

    for (final analysisRecord in report.files) {
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
