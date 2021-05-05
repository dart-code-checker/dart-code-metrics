@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/anti_patterns/patterns_factory.dart';
import 'package:test/test.dart';

void main() {
  test('getPatternsById returns only required patterns', () {
    expect(getPatternsById({}), isEmpty);
    expect(
      getPatternsById({
        'long-method': <String, Object>{},
        'long-parameter-list': <String, Object>{},
        'sample-pattern': <String, Object>{},
      }).map((pattern) => pattern.id),
      equals(['long-method', 'long-parameter-list']),
    );
  });
}
