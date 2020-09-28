import '../../models/code_issue_severity.dart';
import '../../models/file_record.dart';
import '../reporter.dart';
import 'github_workflow_commands.dart';

class GitHubReporter implements Reporter {
  @override
  Iterable<String> report(Iterable<FileRecord> records) {
    final _commands = GitHubWorkflowCommands();

    final reportStrings = <String>[];

    for (final analysisRecord in records) {
      for (final issue in analysisRecord.designIssue) {
        reportStrings.add(
            _commands.warning(issue.message, sourceSpan: issue.sourceSpan));
      }

      for (final issue in analysisRecord.issues) {
        if (issue.severity == CodeIssueSeverity.error) {
          reportStrings.add(
              _commands.error(issue.message, sourceSpan: issue.sourceSpan));
        } else {
          reportStrings.add(
              _commands.warning(issue.message, sourceSpan: issue.sourceSpan));
        }
      }
    }

    return reportStrings;
  }
}
