import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart' as plugin;
import 'package:analyzer_plugin/protocol/protocol_generated.dart' as plugin;
import 'package:source_span/source_span.dart';

import '../analyzers/lint_analyzer/lint_config.dart';
import '../analyzers/lint_analyzer/models/issue.dart';
import '../analyzers/lint_analyzer/models/severity.dart';
import '../config_builder/models/deprecated_option.dart';
import '../utils/path_utils.dart';

plugin.AnalysisErrorFixes codeIssueToAnalysisErrorFixes(
  Issue issue,
  ResolvedUnitResult? unitResult,
) {
  final fileWithIssue = uriToPath(issue.location.sourceUrl) ?? '';

  return plugin.AnalysisErrorFixes(
    plugin.AnalysisError(
      _severityMapping[issue.severity]!,
      plugin.AnalysisErrorType.LINT,
      plugin.Location(
        fileWithIssue,
        issue.location.start.offset,
        issue.location.length,
        issue.location.start.line,
        issue.location.start.column,
        issue.location.end.line,
        issue.location.end.column,
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
}

plugin.AnalysisErrorFixes designIssueToAnalysisErrorFixes(Issue issue) =>
    plugin.AnalysisErrorFixes(plugin.AnalysisError(
      plugin.AnalysisErrorSeverity.INFO,
      plugin.AnalysisErrorType.HINT,
      plugin.Location(
        uriToPath(issue.location.sourceUrl) ?? '',
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

Iterable<plugin.AnalysisErrorFixes> checkConfigDeprecatedOptions(
  LintConfig config,
  Iterable<DeprecatedOption> deprecatedOptions,
  String analysisOptionPath,
) {
  final ids = {
    ...config.codeRules.map((rule) => rule.id),
    ...config.methodsMetrics.map((metric) => metric.id),
    ...config.antiPatterns.map((pattern) => pattern.id),
    ...config.metricsConfig.keys,
  };

  final location =
      SourceLocation(0, sourceUrl: analysisOptionPath, line: 0, column: 0);

  final documentation = Uri.parse(
    'https://github.com/dart-code-checker/dart-code-metrics/blob/master/CHANGELOG.md',
  );

  return deprecatedOptions
      .where((option) => ids.contains(option.deprecated))
      .map((option) => codeIssueToAnalysisErrorFixes(
            Issue(
              ruleId: 'dart-code-metrics',
              documentation: documentation,
              location: SourceSpan(location, location, ''),
              severity: Severity.warning,
              message:
                  '${option.deprecated} deprecated option. This option will be removed in ${option.supportUntilVersion} version.',
              verboseMessage: option.replacement != null
                  ? 'Please migrate on ${option.replacement}, and restart analysis server.'
                  : null,
            ),
            null,
          ))
      .toList();
}

const _severityMapping = {
  Severity.error: plugin.AnalysisErrorSeverity.ERROR,
  Severity.warning: plugin.AnalysisErrorSeverity.WARNING,
  Severity.performance: plugin.AnalysisErrorSeverity.INFO,
  Severity.style: plugin.AnalysisErrorSeverity.INFO,
  Severity.none: plugin.AnalysisErrorSeverity.INFO,
};
