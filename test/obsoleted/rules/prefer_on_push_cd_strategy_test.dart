@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/prefer_on_push_cd_strategy.dart';
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
        // ignore: deprecated_member_use
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false,
      );

      final issues =
          PreferOnPushCdStrategyRule().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(issues, isEmpty);
    });

    test('reports about missing OnPush change detection strategy', () {
      final sourceUrl = Uri.parse('/example.dart');

      final parseResult = parseString(
        content: _contentMissingChangeDetection,
        // ignore: deprecated_member_use
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false,
      );

      final issues =
          PreferOnPushCdStrategyRule().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(issues, hasLength(1));

      final issue = issues.first;
      expect(issue.ruleId, equals('prefer-on-push-cd-strategy'));
      expect(issue.severity, equals(Severity.warning));
      expect(issue.location.sourceUrl, equals(sourceUrl));
      expect(issue.location.start.line, equals(1));
      expect(issue.location.end.line, equals(3));
      expect(issue.message, equals(_issueMessage));
    });

    test('reports about incorrect OnPush change detection strategy', () {
      final sourceUrl = Uri.parse('/example.dart');

      final parseResult = parseString(
        content: _contentIncorrectChangeDetection,
        // ignore: deprecated_member_use
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false,
      );

      final issues =
          PreferOnPushCdStrategyRule().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(issues, hasLength(1));

      final issue = issues.first;
      expect(issue.ruleId, equals('prefer-on-push-cd-strategy'));
      expect(issue.severity, equals(Severity.warning));
      expect(issue.location.sourceUrl, equals(sourceUrl));
      expect(issue.location.start.line, equals(3));
      expect(issue.location.end.line, equals(3));
      expect(issue.message, equals(_issueMessage));
    });
  });
}
