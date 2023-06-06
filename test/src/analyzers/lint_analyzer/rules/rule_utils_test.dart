import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/replacement.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/models/rule.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/models/rule_type.dart';
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
          'https://dcm.dev/docs/rules/flutter/rule-id',
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
        when(() => rule.type).thenReturn(RuleType.flutter);

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
      when(() => rule1.type).thenReturn(RuleType.flutter);

      final rule2 = RuleMock();
      when(() => rule2.id).thenReturn(ruleId2);
      when(() => rule2.type).thenReturn(RuleType.angular);

      expect(
        documentation(rule1).toString(),
        equals(
          'https://dcm.dev/docs/rules/flutter/$ruleId1',
        ),
      );

      final doc2 = [...documentation(rule2).pathSegments];
      expect(doc2.removeLast(), equals(ruleId2));
      expect(doc2.removeLast(), equals(RuleType.angular.value));
    });
  });
}
