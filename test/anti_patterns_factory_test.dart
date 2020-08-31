@TestOn('vm')
import 'package:dart_code_metrics/src/anti_patterns_factory.dart';
import 'package:test/test.dart';

void main() {
  test('getPatternsById returns only required patterns', () {
    expect(getPatternsById({}), isEmpty);
    expect(
        getPatternsById({
          'long-method': <String, Object>{},
          'sample-pattern': <String, Object>{},
        }).single.id,
        equals('long-method'));
  });
}
