@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/replacement.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/models/rule.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rule_utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

class RuleMock extends Mock implements Rule {}

void main() {
  group('Rule utils', () {
    test(
      'createIssue returns information issue based on passed information',
      () {
        const id = 'rule-id';
        final documentationUrl = Uri.parse(
          'https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/rule-id.md',
        );
        const severity = Severity.none;

        final codeUrl = Uri.parse('file://source.dart');
        final codeLocation = SourceSpan(
          SourceLocation(0, sourceUrl: codeUrl),
          SourceLocation(4, sourceUrl: codeUrl),
          'code',
        );

        const message = 'error message';

        const verboseMessage = 'information how to fix a error';

        const replacement =
            Replacement(comment: 'comment', replacement: 'new code');

        final rule = RuleMock();
        when(() => rule.id).thenReturn(id);
        when(() => rule.severity).thenReturn(severity);

        final issue = createIssue(
          rule: rule,
          location: codeLocation,
          message: message,
          verboseMessage: verboseMessage,
          replacement: replacement,
        );

        expect(issue.ruleId, equals(id));
        expect(issue.documentation, equals(documentationUrl));
        expect(issue.location, equals(codeLocation));
        expect(issue.severity, equals(severity));
        expect(issue.message, equals(message));
        expect(issue.verboseMessage, equals(verboseMessage));
        expect(issue.suggestion, equals(replacement));
      },
    );

    test('documentation returns the url with documentation', () {
      const ruleId1 = 'rule-id-1';
      const ruleId2 = 'rule-id-2';

      final rule1 = RuleMock();
      when(() => rule1.id).thenReturn(ruleId1);

      final rule2 = RuleMock();
      when(() => rule2.id).thenReturn(ruleId2);

      expect(
        documentation(rule1).toString(),
        equals(
          'https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/$ruleId1.md',
        ),
      );
      expect(
        documentation(rule2).pathSegments.last,
        equals('$ruleId2.md'),
      );
    });

    test('readSeverity returns a Severity from Map based config', () {
      expect(
        [
          {'severity': 'ERROR'},
          {'severity': 'wArnInG'},
          {'severity': 'performance'},
          {'severity': ''},
          {'': null},
        ].map((data) => readSeverity(data, Severity.style)),
        equals([
          Severity.error,
          Severity.warning,
          Severity.performance,
          Severity.none,
          Severity.style,
        ]),
      );
    });

    group('readExcludes', () {
      test('returns a list of excludes', () {
        const excludes = [
          'hello.dart',
          'world/**',
        ];

        expect(readExcludes({'exclude': excludes}), equals(excludes));
      });

      test('returns an empty list', () {
        const wrongExcludes = [1, 2];

        expect(readExcludes({'exclude': wrongExcludes}), isEmpty);
      });
    });
  });
}
