import 'package:code_checker/rules.dart';

import '../../models/file_record.dart';
import '../reporter.dart';
import 'github_workflow_commands.dart';

/// Creates report about issues in pull request based on GitHub Actions Workflow commands.

class GitHubReporter implements Reporter {
  @override
  Future<Iterable<String>> report(Iterable<FileRecord> records) async {
    final _commands = GitHubWorkflowCommands();

    final reportStrings = <String>[];

    for (final analysisRecord in records) {
      for (final issue in analysisRecord.designIssues) {
        reportStrings
            .add(_commands.warning(issue.message, sourceSpan: issue.location));
      }

      for (final issue in analysisRecord.issues) {
        if (issue.severity == Severity.error) {
          reportStrings
              .add(_commands.error(issue.message, sourceSpan: issue.location));
        } else {
          reportStrings.add(
            _commands.warning(issue.message, sourceSpan: issue.location),
          );
        }
      }
    }

    return reportStrings;
  }
}
