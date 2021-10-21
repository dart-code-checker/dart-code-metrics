import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

import '../../../../../reporters/models/json_reporter.dart';
import '../../../models/unused_l10n_file_report.dart';
import '../../../models/unused_l10n_issue.dart';

/// Unused localization JSON reporter.
///
/// Use it to create reports in JSON format.
@immutable
class UnusedL10nJsonReporter extends JsonReporter<UnusedL10nFileReport, void> {
  const UnusedL10nJsonReporter(IOSink output) : super(output, 2);

  @override
  Future<void> report(
    Iterable<UnusedL10nFileReport> records, {
    Iterable<void> summary = const [],
  }) async {
    if (records.isEmpty) {
      return;
    }

    final encodedReport = json.encode({
      'formatVersion': formatVersion,
      'timestamp': getTimestamp(),
      'unusedLocalizations': records.map(_unusedL10nFileReportToJson).toList(),
    });

    output.write(encodedReport);
  }

  Map<String, Object> _unusedL10nFileReportToJson(
    UnusedL10nFileReport report,
  ) =>
      {
        'path': report.relativePath,
        'className': report.className,
        'issues': report.issues.map(_issueToJson).toList(),
      };

  Map<String, Object> _issueToJson(UnusedL10nIssue issue) => {
        'memberName': issue.memberName,
        'column': issue.location.column,
        'line': issue.location.line,
        'offset': issue.location.offset,
      };
}
