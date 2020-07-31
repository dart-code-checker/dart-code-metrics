@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/prefer_on_push_cd_strategy.dart';
import 'package:test/test.dart';

const _contentCorrect = '''
@Component(
  selector: 'component-selector',
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class Component {}
''';

const _contentMissingChangeDetection = '''
@Component(
  selector: 'component-selector',
)
class Component {}
''';

const _contentIncorrectChangeDetection = '''
@Component(
  selector: 'component-selector',
  changeDetection: ChangeDetectionStrategy.Stateful,
)
class Component {}
''';

const _issueMessage = 'Prefer using onPush change detection strategy.';

void main() {
  group('PreferOnPushCdStrategy', () {
    test('do nothing if component has OnPush change detection strategy', () {
      final sourceUrl = Uri.parse('/example.dart');

      final parseResult = parseString(
          content: _contentCorrect,
          featureSet: FeatureSet.fromEnableFlags([]),
          throwIfDiagnostics: false);

      final issues = PreferOnPushCdStrategyRule()
          .check(parseResult.unit, sourceUrl, parseResult.content);

      expect(issues, isEmpty);
    });

    test('reports about missing OnPush change detection strategy', () {
      final sourceUrl = Uri.parse('/example.dart');

      final parseResult = parseString(
          content: _contentMissingChangeDetection,
          featureSet: FeatureSet.fromEnableFlags([]),
          throwIfDiagnostics: false);

      final issues = PreferOnPushCdStrategyRule()
          .check(parseResult.unit, sourceUrl, parseResult.content);

      expect(issues.length, equals(1));

      final issue = issues.first;
      expect(issue.ruleId, equals('prefer-on-push-cd-strategy'));
      expect(issue.severity, equals(CodeIssueSeverity.warning));
      expect(issue.sourceSpan.sourceUrl, equals(sourceUrl));
      expect(issue.sourceSpan.start.line, equals(1));
      expect(issue.sourceSpan.end.line, equals(3));
      expect(issue.message, equals(_issueMessage));
    });

    test('reports about incorrect OnPush change detection strategy', () {
      final sourceUrl = Uri.parse('/example.dart');

      final parseResult = parseString(
          content: _contentIncorrectChangeDetection,
          featureSet: FeatureSet.fromEnableFlags([]),
          throwIfDiagnostics: false);

      final issues = PreferOnPushCdStrategyRule()
          .check(parseResult.unit, sourceUrl, parseResult.content);

      expect(issues.length, equals(1));

      final issue = issues.first;
      expect(issue.ruleId, equals('prefer-on-push-cd-strategy'));
      expect(issue.severity, equals(CodeIssueSeverity.warning));
      expect(issue.sourceSpan.sourceUrl, equals(sourceUrl));
      expect(issue.sourceSpan.start.line, equals(3));
      expect(issue.sourceSpan.end.line, equals(3));
      expect(issue.message, equals(_issueMessage));
    });
  });
}
