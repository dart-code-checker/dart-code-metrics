import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart' as plugin;
import 'package:analyzer_plugin/protocol/protocol_generated.dart' as plugin;
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:source_span/source_span.dart';

bool isSupported(AnalysisResult result) =>
    result.path != null &&
    result.path.endsWith('.dart') &&
    !result.path.endsWith('.g.dart');

plugin.AnalysisErrorFixes codeIssueToAnalysisErrorFixes(
        CodeIssue issue, ResolvedUnitResult unitResult) =>
    plugin.AnalysisErrorFixes(
        plugin.AnalysisError(
            _severityMapping[issue.severity],
            plugin.AnalysisErrorType.LINT,
            plugin.Location(
                issue.sourceSpan.sourceUrl.path,
                issue.sourceSpan.start.offset,
                issue.sourceSpan.length,
                issue.sourceSpan.start.line,
                issue.sourceSpan.start.column),
            issue.message,
            issue.ruleId,
            correction: issue.correction,
            url: issue.ruleDocumentationUri?.toString(),
            hasFix: issue.correction != null),
        fixes: [
          if (issue.correction != null)
            plugin.PrioritizedSourceChange(
                1,
                plugin.SourceChange(issue.correctionComment, edits: [
                  plugin.SourceFileEdit(
                      unitResult.libraryElement.source.fullName,
                      unitResult.libraryElement.source.modificationStamp,
                      edits: [
                        plugin.SourceEdit(issue.sourceSpan.start.offset,
                            issue.sourceSpan.length, issue.correction),
                      ]),
                ])),
        ]);

plugin.AnalysisErrorFixes metricReportToAnalysisErrorFixes(
        SourceLocation startLocation,
        int length,
        String message,
        String metricId) =>
    plugin.AnalysisErrorFixes(plugin.AnalysisError(
        plugin.AnalysisErrorSeverity.INFO,
        plugin.AnalysisErrorType.LINT,
        plugin.Location(startLocation.sourceUrl.path, startLocation.offset,
            length, startLocation.line, startLocation.column),
        message,
        metricId,
        hasFix: false));

const _severityMapping = {
  CodeIssueSeverity.style: plugin.AnalysisErrorSeverity.INFO,
  CodeIssueSeverity.warning: plugin.AnalysisErrorSeverity.WARNING,
};
