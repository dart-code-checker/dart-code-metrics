import 'package:dart_code_metrics/src/analyzers/lint_analyzer/anti_patterns/models/pattern.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/anti_patterns/pattern_utils.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

class PatternMock extends Mock implements Pattern {}

void main() {
  group('Pattern utils', () {
    test(
      'createIssue returns information issue based on passed information',
      () {
        const id = 'pattern-id';
        final documentationUrl = Uri.parse(
          'https://dcm.dev/docs/anti-patterns/pattern-id',
        );
        const severity = Severity.none;

        final codeUrl = Uri.parse('file://source.dart');
        final codeLocation = SourceSpan(
          SourceLocation(0, sourceUrl: codeUrl),
          SourceLocation(4, sourceUrl: codeUrl),
          'code',
        );

        const message = 'warning message';

        const verboseMessage = 'recomendations how to fix a error';

        final pattern = PatternMock();
        when(() => pattern.id).thenReturn(id);
        when(() => pattern.severity).thenReturn(severity);

        final issue = createIssue(
          pattern: pattern,
          location: codeLocation,
          message: message,
          verboseMessage: verboseMessage,
        );

        expect(issue.ruleId, equals(id));
        expect(issue.documentation, equals(documentationUrl));
        expect(issue.location, equals(codeLocation));
        expect(issue.severity, equals(severity));
        expect(issue.message, equals(message));
        expect(issue.verboseMessage, equals(verboseMessage));
      },
    );

    test('documentation returns the url with documentation', () {
      const patternId1 = 'pattern-id-1';
      const patternId2 = 'pattern-id-2';

      final pattern1 = PatternMock();
      when(() => pattern1.id).thenReturn(patternId1);

      final pattern2 = PatternMock();
      when(() => pattern2.id).thenReturn(patternId2);

      expect(
        documentation(pattern1).toString(),
        equals(
          'https://dcm.dev/docs/anti-patterns/$patternId1',
        ),
      );
      expect(
        documentation(pattern2).pathSegments.last,
        equals(patternId2),
      );
    });
  });
}
