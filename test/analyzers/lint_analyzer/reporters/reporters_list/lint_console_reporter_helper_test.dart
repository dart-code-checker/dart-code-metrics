@TestOn('vm')
import 'package:ansicolor/ansicolor.dart';
import 'package:dart_code_metrics/lint_analyzer.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/issue.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/console/lint_console_reporter_helper.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

import '../../../../stubs_builders.dart';

void main() {
  group('LintConsoleReporterHelper', () {
    late LintConsoleReporterHelper helper;

    setUp(() {
      ansiColorDisabled = false;

      helper = LintConsoleReporterHelper();
    });

    test('getIssueMessage returns formatted message', () {
      final location = SourceSpan(
        SourceLocation(0, line: 1, column: 2),
        SourceLocation(1, line: 2, column: 3),
        ' ',
      );

      expect(
        helper.getIssueMessage(
          Issue(
            ruleId: 'rule',
            documentation: Uri.parse('https://dartcodemetrics/rules/rule'),
            location: location,
            severity: Severity.warning,
            message: 'Issue message',
            verboseMessage: 'Issue verbose message',
          ),
        ),
        equals('\x1B[38;5;11mWarning \x1B[0mIssue message : 1:2 : rule'),
      );

      expect(
        helper.getIssueMessage(
          Issue(
            ruleId: 'rule',
            documentation: Uri.parse('https://dartcodemetrics/rules/rule'),
            location: location,
            severity: Severity.none,
            message: 'Issue message',
            verboseMessage: 'Issue verbose message',
          ),
        ),
        equals('\x1B[38;5;7m        \x1B[0mIssue message : 1:2 : rule'),
      );
    });

    test('getMetricMessage returns formatted message', () {
      expect(
        helper.getMetricMessage(
          MetricValueLevel.alarm,
          'Class.method',
          ['violation1', 'violation2'],
        ),
        equals(
          '\x1B[38;5;9mAlarm   \x1B[0mClass.method - violation1, violation2',
        ),
      );

      expect(
        helper.getMetricMessage(
          MetricValueLevel.none,
          'Class.method',
          ['violation1', 'violation2'],
        ),
        equals(
          '\x1B[38;5;7m        \x1B[0mClass.method - violation1, violation2',
        ),
      );
    });

    test('getMetricReport returns formatted message', () {
      expect(
        helper.getMetricReport(buildMetricValueStub(id: 'metricId', value: 12)),
        equals('metricid: \x1B[38;5;7m12\x1B[0m'),
      );
    });
  });
}
