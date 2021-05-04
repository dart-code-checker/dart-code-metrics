import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart' as plugin;
import 'package:analyzer_plugin/protocol/protocol_generated.dart' as plugin;
import 'package:source_span/source_span.dart';

import '../analyzers/models/issue.dart';
import '../analyzers/models/severity.dart';

bool isSupported(AnalysisResult result) =>
    result.path != null &&
    result.path!.endsWith('.dart') &&
    !result.path!.endsWith('.g.dart');

plugin.AnalysisErrorFixes codeIssueToAnalysisErrorFixes(
  Issue issue,
  ResolvedUnitResult unitResult,
) =>
    plugin.AnalysisErrorFixes(
      plugin.AnalysisError(
        _severityMapping[issue.severity]!,
        plugin.AnalysisErrorType.LINT,
        plugin.Location(
          issue.location.sourceUrl!.path,
          issue.location.start.offset,
          issue.location.length,
          issue.location.start.line,
          issue.location.start.column,
          issue.location.end.line,
          issue.location.end.column,
        ),
        issue.message,
        issue.ruleId,
        correction: issue.suggestion?.replacement,
        url: issue.documentation.toString(),
        hasFix: issue.suggestion != null,
      ),
      fixes: [
        if (issue.suggestion != null)
          plugin.PrioritizedSourceChange(
            1,
            plugin.SourceChange(issue.suggestion!.comment, edits: [
              plugin.SourceFileEdit(
                unitResult.libraryElement.source.fullName,
                unitResult.libraryElement.source.modificationStamp,
                edits: [
                  plugin.SourceEdit(
                    issue.location.start.offset,
                    issue.location.length,
                    issue.suggestion!.replacement,
                  ),
                ],
              ),
            ]),
          ),
      ],
    );

plugin.AnalysisErrorFixes designIssueToAnalysisErrorFixes(Issue issue) =>
    plugin.AnalysisErrorFixes(plugin.AnalysisError(
      plugin.AnalysisErrorSeverity.INFO,
      plugin.AnalysisErrorType.HINT,
      plugin.Location(
        issue.location.sourceUrl!.path,
        issue.location.start.offset,
        issue.location.length,
        issue.location.start.line,
        issue.location.start.column,
        issue.location.end.line,
        issue.location.end.column,
      ),
      issue.message,
      issue.ruleId,
      correction: issue.verboseMessage,
      url: issue.documentation.toString(),
      hasFix: false,
    ));

plugin.AnalysisErrorFixes metricReportToAnalysisErrorFixes(
  SourceLocation startLocation,
  int length,
  String message,
  String metricId,
) =>
    plugin.AnalysisErrorFixes(plugin.AnalysisError(
      plugin.AnalysisErrorSeverity.INFO,
      plugin.AnalysisErrorType.LINT,
      plugin.Location(
        startLocation.sourceUrl!.path,
        startLocation.offset,
        length,
        startLocation.line,
        startLocation.column,
        startLocation.line,
        startLocation.column,
      ),
      message,
      metricId,
      hasFix: false,
    ));

const _severityMapping = {
  Severity.error: plugin.AnalysisErrorSeverity.ERROR,
  Severity.warning: plugin.AnalysisErrorSeverity.WARNING,
  Severity.performance: plugin.AnalysisErrorSeverity.INFO,
  Severity.style: plugin.AnalysisErrorSeverity.INFO,
  Severity.none: plugin.AnalysisErrorSeverity.INFO,
};
