@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/component_annotation_arguments_ordering.dart';
import 'package:test/test.dart';

const _content = '''

@Component(
  selector: 'component-selector',
  template: '<div></div>',
  changeDetection: ChangeDetectionStrategy.OnPush,
  styleUrls: [],
)
class Component {}

''';

void main() {
  group('ComponentAnnotationArgumentsOrdering', () {
    final sourceUrl = Uri.parse('/example.dart');
    final parseResult = parseString(
      content: _content,
      // ignore: deprecated_member_use
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    test('initialization', () {
      final issues = ComponentAnnotationArgumentsOrderingRule()
          .check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.every((issue) =>
            issue.ruleId == 'component-annotation-arguments-ordering'),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.severity == Severity.style),
        isTrue,
      );
    });

    test('with default config reports about found issues', () {
      final issues = ComponentAnnotationArgumentsOrderingRule()
          .check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.map((issue) => issue.location.start.offset),
        equals([127]),
      );
      expect(
        issues.map((issue) => issue.location.start.line),
        equals([6]),
      );
      expect(
        issues.map((issue) => issue.location.start.column),
        equals([3]),
      );
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals([140]),
      );
      expect(
        issues.map((issue) => issue.location.text),
        equals([
          'styleUrls: []',
        ]),
      );
      expect(
        issues.map((issue) => issue.message),
        equals([
          'Arguments group styles should be before change_detection',
        ]),
      );
    });

    test('with custom config reports about no found issues', () {
      final config = {
        'order': [
          'selector',
          'templates',
        ],
      };

      final issues = ComponentAnnotationArgumentsOrderingRule(config: config)
          .check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(issues.isEmpty, isTrue);
    });

    test('with custom config reports about found issues', () {
      final config = {
        'order': [
          'change_detection',
          'templates',
          'selector',
          'styles',
        ],
      };

      final issues = ComponentAnnotationArgumentsOrderingRule(config: config)
          .check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.map((issue) => issue.location.start.offset),
        equals([49, 76]),
      );
      expect(
        issues.map((issue) => issue.location.start.line),
        equals([4, 5]),
      );
      expect(
        issues.map((issue) => issue.location.start.column),
        equals([3, 3]),
      );
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals([72, 123]),
      );
      expect(
        issues.map((issue) => issue.location.text),
        equals([
          "template: '<div></div>'",
          'changeDetection: ChangeDetectionStrategy.OnPush',
        ]),
      );
      expect(
        issues.map((issue) => issue.message),
        equals([
          'Arguments group templates should be before selector',
          'Arguments group change_detection should be before templates',
        ]),
      );
    });
  });
}
