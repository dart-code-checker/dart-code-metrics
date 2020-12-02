@TestOn('vm')
import 'dart:convert';

import 'package:dart_code_metrics/src/config/config.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/design_issue.dart';
import 'package:dart_code_metrics/src/models/file_record.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/reporters/code_climate/code_climate_reporter.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

import '../stubs_builders.dart';

void main() {
  group('CodeClimateReporter.report report about', () {
    const fullPath = '/home/developer/work/project/example.dart';

    CodeClimateReporter _reporter;

    setUp(() {
      _reporter = CodeClimateReporter(reportConfig: const Config());
    });

    test('empty file', () {
      expect(_reporter.report([]), isEmpty);
    });

    test('file with design issues', () {
      const _issuePatternId = 'patternId1';
      const _issuePatternDocumentation = 'https://docu.edu/patternId1.html';
      const _issueLine = 2;
      const _issueMessage = 'first issue message';
      const _issueRecommendation = 'issue recommendation';

      final records = [
        FileRecord(
          fullPath: fullPath,
          relativePath: 'example.dart',
          components: Map.unmodifiable(<String, ComponentRecord>{}),
          functions: Map.unmodifiable(<String, FunctionRecord>{}),
          issues: const [],
          designIssues: [
            DesignIssue(
              patternId: _issuePatternId,
              patternDocumentation: Uri.parse(_issuePatternDocumentation),
              sourceSpan: SourceSpanBase(
                SourceLocation(
                  1,
                  sourceUrl: Uri.parse(fullPath),
                  line: _issueLine,
                  column: 3,
                ),
                SourceLocation(6, sourceUrl: Uri.parse(fullPath)),
                'issue',
              ),
              message: 'first issue message',
              recommendation: _issueRecommendation,
            ),
          ],
        ),
      ];

      final report =
          (json.decode(_reporter.report(records).first) as List<Object>).first
              as Map<String, Object>;

      expect(report, containsPair('type', 'issue'));
      expect(report, containsPair('check_name', _issuePatternId));
      expect(report, containsPair('description', _issueMessage));
      expect(report, containsPair('categories', ['Complexity']));
      expect(
          report,
          containsPair('location', {
            'path': 'example.dart',
            'lines': {'begin': _issueLine, 'end': _issueLine},
          }));
      expect(report, containsPair('remediation_points', 50000));
      expect(report, containsPair('severity', 'info'));
      expect(report,
          containsPair('fingerprint', '8842a666b8aee4f2eae51205e0114dae'));
    });

    test('file with style severity issues', () {
      const _issueRuleId = 'ruleId1';
      const _issueRuleDocumentation = 'https://docu.edu/ruleId1.html';

      const _issueLine = 2;
      const _issueMessage = 'first issue message';

      final records = [
        FileRecord(
          fullPath: fullPath,
          relativePath: 'example.dart',
          components: Map.unmodifiable(<String, ComponentRecord>{}),
          functions: Map.unmodifiable(<String, FunctionRecord>{}),
          issues: [
            CodeIssue(
              ruleId: _issueRuleId,
              ruleDocumentation: Uri.parse(_issueRuleDocumentation),
              severity: CodeIssueSeverity.style,
              sourceSpan: SourceSpanBase(
                SourceLocation(
                  1,
                  sourceUrl: Uri.parse(fullPath),
                  line: _issueLine,
                  column: 3,
                ),
                SourceLocation(6, sourceUrl: Uri.parse(fullPath)),
                'issue',
              ),
              message: _issueMessage,
              correction: 'correction',
              correctionComment: 'correction comment',
            ),
          ],
          designIssues: const [],
        ),
      ];

      final report =
          (json.decode(_reporter.report(records).first) as List<Object>).first
              as Map<String, Object>;

      expect(report, containsPair('type', 'issue'));
      expect(report, containsPair('check_name', _issueRuleId));
      expect(report, containsPair('description', _issueMessage));
      expect(report, containsPair('categories', ['Style']));
      expect(
        report,
        containsPair('location', {
          'path': 'example.dart',
          'lines': {'begin': _issueLine, 'end': _issueLine},
        }),
      );
      expect(report, containsPair('remediation_points', 50000));
      expect(report, containsPair('severity', 'minor'));

      expect(
        report,
        containsPair('fingerprint', 'ed45b12bc8354f240bfe37e1c1eb0f58'),
      );
    });

    group('components', () {
      test('without methods', () {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{
              'class': buildComponentRecordStub(methodsCount: 0),
            }),
            functions: Map.unmodifiable(<String, FunctionRecord>{}),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report =
            json.decode(_reporter.report(records).first) as List<Object>;

        expect(report, isEmpty);
      });

      test('with a lot of methods', () {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{
              'class': buildComponentRecordStub(methodsCount: 20),
            }),
            functions: Map.unmodifiable(<String, FunctionRecord>{}),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report =
            (json.decode(_reporter.report(records).first) as List<Object>).first
                as Map<String, Object>;

        expect(report, containsPair('type', 'issue'));
        expect(report, containsPair('check_name', 'numberOfMethods'));
        expect(
          report,
          containsPair(
            'description',
            'Component `class` has 20 number of methods (exceeds 10 allowed). Consider refactoring.',
          ),
        );
        expect(report, containsPair('categories', ['Complexity']));
        expect(
          report,
          containsPair(
            'location',
            {
              'path': 'example.dart',
              'lines': {'begin': 0, 'end': 0},
            },
          ),
        );
        expect(report, containsPair('remediation_points', 50000));
        expect(report, containsPair('severity', 'info'));

        expect(
          report,
          containsPair('fingerprint', 'de1258f0c898f266343b3e435e23310c'),
        );
      });
    });

    group('function', () {
      test('with short body', () {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(
                  linesWithCode: List.generate(5, (index) => index)),
            }),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report =
            json.decode(_reporter.report(records).first) as List<Object>;

        expect(report, isEmpty);
      });

      test('without arguments', () {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(argumentsCount: 0),
            }),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report =
            json.decode(_reporter.report(records).first) as List<Object>;

        expect(report, isEmpty);
      });
    });
  });
}
