@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/avoid_preserve_whitespace_false.dart';
import 'package:test/test.dart';

const _content = '''
@Component(
  selector: 'component-selector',
  templateUrl: 'component.html',
  styleUrls: ['component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  preserveWhitespace: false,
  directives: <Object>[
    coreDirectives,
  ],
)
class Component {}

@Component(
  selector: 'component2-selector',
  templateUrl: 'component2.html',
  styleUrls: ['component2.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: <Object>[
    coreDirectives,
  ],
)
class Component2 {}

@Component(
  selector: 'component3-selector',
  templateUrl: 'component3.html',
  styleUrls: ['component3.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  preserveWhitespace: true,
  directives: <Object>[
    coreDirectives,
  ],
)
class Component3 {}
''';

void main() {
  test('AvoidPreserveWhitespaceFalseRule reports about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
      content: _content,
      // ignore: deprecated_member_use
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    final issues =
        AvoidPreserveWhitespaceFalseRule().check(InternalResolvedUnitResult(
      sourceUrl,
      parseResult.content,
      parseResult.unit,
    ));

    expect(issues, hasLength(1));

    final issue = issues.first;
    expect(issue.ruleId, equals('avoid-preserve-whitespace-false'));
    expect(issue.severity, equals(Severity.warning));
    expect(issue.location.sourceUrl, equals(sourceUrl));
    expect(issue.location.start.offset, equals(164));
    expect(issue.location.start.line, equals(6));
    expect(issue.location.start.column, equals(3));
    expect(issue.location.end.offset, equals(189));
    expect(issue.location.end.line, equals(6));
    expect(issue.location.end.column, equals(28));
    expect(issue.location.text, equals('preserveWhitespace: false'));
    expect(issue.message, equals('Avoid using preserveWhitespace: false.'));
    expect(issue.suggestion, isNull);
  });
}
