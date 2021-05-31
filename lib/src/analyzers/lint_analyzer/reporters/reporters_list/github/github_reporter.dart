import 'dart:io';

import '../../../../models/file_report.dart';
import '../../../../models/severity.dart';
import '../../models/reporter.dart';
import 'github_workflow_commands.dart';

/// Creates report about issues in pull request based on GitHub Actions Workflow commands.

class GitHubReporter implements Reporter {
  final IOSink _output;

  const GitHubReporter(this._output);

  @override
  Future<void> report(Iterable<FileReport> records) async {
    if (records.isEmpty) {
      return;
    }

    final _commands = GitHubWorkflowCommands();

    for (final analysisRecord in records) {
      for (final antiPattern in analysisRecord.antiPatternCases) {
        _output.writeln(_commands.warning(
          antiPattern.message,
          absolutePath: analysisRecord.path,
          sourceSpan: antiPattern.location,
        ));
      }

      for (final issue in analysisRecord.issues) {
        _output.writeln(
          issue.severity == Severity.error
              ? _commands.error(
                  issue.message,
                  absolutePath: analysisRecord.path,
                  sourceSpan: issue.location,
                )
              : _commands.warning(
                  issue.message,
                  absolutePath: analysisRecord.path,
                  sourceSpan: issue.location,
                ),
        );
      }
    }
  }
}
