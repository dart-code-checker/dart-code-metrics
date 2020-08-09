@TestOn('vm')

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/prefer_intl_name.dart';
import 'package:test/test.dart';

// ignore_for_file: use_raw_strings

const _incorrectContent = '''
import 'package:intl/intl.dart';

final Iterable<String> titles = ['first', 'second'];
final title = 'first';

class ClassI18n {
  static final String staticFinalFieldInClassTitle = Intl.message(
    'static final field in class \$title,
    name: 'ClassI18n_staticFinalFieldInClassTitle',
    args: <Object>[],
  );

  static String get staticPropertyWithExpressionInClassTitle => Intl.message(
        'static property with expression in class \$title',
        name: 'ClassI18n_staticPropertyWithExpressionInClassTitle',
      );

  static String staticMethodExpressionInClassTitle(String title) => Intl.message(
        'static method with expression in class \$title',
        name: 'ClassI18n_staticMethodExpressionInClassTitle',
      );

  final String finalFieldInClassTitle = Intl.message(
    'final field in class \${titles.map((title) => title)} \$title',
    name: 'ClassI18n_finalFieldInClassTitle',
    args: <Object>[titles],
  );

  String get propertyWithExpressionInClassTitle => Intl.message(
        'property with expression in class \${titles.map((title) => title)} \$title',
        name: 'ClassI18n_propertyWithExpressionInClassTitle',
        args: <Object>[title],
      );
}
''';

const _correctContent = '''
import 'package:intl/intl.dart';

final Iterable<String> titles = ['first', 'second'];
final title = 'first';

final String finalFieldTitle = Intl.message(
  'final field \${titles.map((title) => title)} \$title',
  name: 'finalFieldTitle',
  args: <Object>[titles, title],
);

String get propertyWithExpressionTitle => Intl.message(
  'property with expression \${titles.map((title) => title)}',
  name: 'propertyWithExpressionTitle',
  args: <Object>[titles],
);

String methodExpressionTitle(String title) => Intl.message(
  'method with expression \$title',
  name: 'methodExpressionTitle',
  args: <Object>[title],
);

String methodExpressionTitleEmptyArgument() => Intl.message(
  'method with expression \$title',
  name: 'methodExpressionTitleEmptyArgument',
  args: <Object>[title],
);

String methodExpressionTitleEmptyArgs() => Intl.message(
  'method with expression',
  name: 'methodExpressionTitleEmptyArgs',
  args: <Object>[],
);
''';

void main() {
  group('PreferIntlNameRule reports', () {
    final sourceUrl = Uri.parse('/example.dart');

    test('found issues', () {
      final parseResult = parseString(
          content: _incorrectContent,
          featureSet: FeatureSet.fromEnableFlags([]),
          throwIfDiagnostics: false);

      final issues = PreferIntlNameRule()
          .check(parseResult.unit, sourceUrl, parseResult.content);

      expect(
        issues.every((issue) => issue.ruleId == 'prefer-intl-name'),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.severity == CodeIssueSeverity.warning),
        isTrue,
      );

      expect(
        issues.map((issue) => issue.sourceSpan.start.offset),
        equals([299, 386, 605, 920, 1169]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.start.line),
        equals([10, 13, 18, 26, 32]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.start.column),
        equals([11, 70, 74, 11, 15]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.end.offset),
        equals([309, 393, 612, 936, 1184]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.text),
        equals([
          '<Object>[]',
          'message',
          'message',
          '<Object>[titles]',
          '<Object>[title]',
        ]),
      );
      expect(
        issues.map((issue) => issue.message),
        equals([
          'title is not provided to args',
          'No arguments provided for interpolation',
          'No arguments provided for interpolation',
          'title is not provided to args',
          'titles is not provided to args',
        ]),
      );
    });

    test('no found issues', () {
      final parseResult = parseString(
          content: _correctContent,
          featureSet: FeatureSet.fromEnableFlags([]),
          throwIfDiagnostics: false);

      final issues = PreferIntlNameRule()
          .check(parseResult.unit, sourceUrl, parseResult.content);

      expect(issues, isEmpty);
    });
  });
}
