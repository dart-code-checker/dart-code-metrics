@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/anti_patterns/long_method.dart';
import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/models/source.dart';
import 'package:test/test.dart';

const _content = '''

void main() {
  test('LongMethod report about found design issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
        content: _content,
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false);

    final issues = LongMethod().check(
        parseResult.unit,
        sourceUrl,
        parseResult.content,
        const Config(linesOfExecutableCodeWarningLevel: 25));

    expect(issues.length, equals(1));

    expect(issues.single.patternId, equals('long-method'));
    expect(issues.single.patternDocumentation.toString(),
        equals('https://git.io/JUIP7'));
    expect(issues.single.sourceSpan.sourceUrl, equals(sourceUrl));
    expect(issues.single.sourceSpan.start.offset, equals(1));
    expect(issues.single.sourceSpan.start.line, equals(2));
    expect(issues.single.sourceSpan.start.column, equals(1));
    expect(issues.single.sourceSpan.end.offset, equals(1314));
    expect(
        issues.single.message,
        equals(
            'Long Method. This method contains 29 lines with executable code.'));
    expect(
        issues.single.recommendation,
        equals(
            "Based on configuration of this package, we don't recommend write a method longer than 25 lines with executable code."));
  });
}

''';

void main() {
  test('LongMethod report about found design issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
      content: _content,
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    final issues = LongMethod().check(
        Source(sourceUrl, parseResult.content, parseResult.unit),
        const Config(linesOfExecutableCodeWarningLevel: 25));

    expect(issues.length, equals(1));

    expect(issues.single.patternId, equals('long-method'));
    expect(issues.single.patternDocumentation.toString(),
        equals('https://git.io/JUIP7'));
    expect(issues.single.sourceSpan.sourceUrl, equals(sourceUrl));
    expect(issues.single.sourceSpan.start.offset, equals(1));
    expect(issues.single.sourceSpan.start.line, equals(2));
    expect(issues.single.sourceSpan.start.column, equals(1));
    expect(issues.single.sourceSpan.end.offset, equals(1314));
    expect(
      issues.single.message,
      equals(
          'Long Method. This method contains 29 lines with executable code.'),
    );
    expect(
      issues.single.recommendation,
      equals(
          "Based on configuration of this package, we don't recommend write a method longer than 25 lines with executable code."),
    );
  });
}
