import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart' as plugin;
import 'package:analyzer_plugin/protocol/protocol_generated.dart' as plugin;

import '../analyzers/lint_analyzer/models/issue.dart';
import '../analyzers/lint_analyzer/models/severity.dart';
import '../utils/path_utils.dart';

plugin.AnalysisErrorFixes codeIssueToAnalysisErrorFixes(
  Issue issue,
  ResolvedUnitResult? unitResult,
) {
  final fileWithIssue = uriToPath(issue.location.sourceUrl) ?? '';
  final location = issue.location;
  final locationStart = location.start;
  final locationEnd = location.end;

  return plugin.AnalysisErrorFixes(
    plugin.AnalysisError(
      _severityMapping[issue.severity]!,
      plugin.AnalysisErrorType.LINT,
      plugin.Location(
        fileWithIssue,
        locationStart.offset,
        location.length,
        locationStart.line,
        locationStart.column,
        endLine: locationEnd.line,
        endColumn: locationEnd.column,
      ),
      issue.message,
      issue.ruleId,
      correction:
          '${issue.verboseMessage ?? ''} ${issue.suggestion?.replacement ?? ''}'
              .trim(),
      url: issue.documentation.toString(),
      hasFix: issue.suggestion != null,
    ),
    fixes: [
      if (issue.suggestion != null && unitResult != null)
        plugin.PrioritizedSourceChange(
          1,
          plugin.SourceChange(issue.suggestion!.comment, edits: [
            plugin.SourceFileEdit(
              fileWithIssue,
              // based on discussion https://groups.google.com/a/dartlang.org/g/analyzer-discuss/c/lfRzX0yw3ZU
              unitResult.exists ? 0 : -1,
              edits: [
                plugin.SourceEdit(
                  locationStart.offset,
                  location.length,
                  issue.suggestion!.replacement,
                ),
              ],
            ),
          ]),
        ),
    ],
  );
}

const _severityMapping = {
  Severity.error: plugin.AnalysisErrorSeverity.ERROR,
  Severity.warning: plugin.AnalysisErrorSeverity.WARNING,
  Severity.performance: plugin.AnalysisErrorSeverity.INFO,
  Severity.style: plugin.AnalysisErrorSeverity.INFO,
  Severity.none: plugin.AnalysisErrorSeverity.INFO,
};
