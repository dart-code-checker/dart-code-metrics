@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/provide_correct_intl_args.dart';
import 'package:test/test.dart';

const _content = r'''
import 'package:intl/intl.dart';    
//Correct

class SomeButtonClassI18n {

  static String simpleTitle() {
    return Intl.message(
      'title',
      name: 'SomeButtonClassI18n_simpleTitle',
    );
  }

  static String sourceTitle(String source, String openTag, String closeTag) => Intl.message(
        'Connector: $openTag$source$closeTag',
        args: [
          source,
          openTag,
          closeTag,
        ],
        name: 'SomeButtonClassI18n_sourceTitle',
      );

  static String titleWithParameter(String name) {
    return Intl.message(
      'title $name',
      name: 'SomeButtonClassI18n_titleWithParameter',
      args: [name],
    );
  }

  static String titleWithManyParameter(String name, int value) {
    return Intl.message(
      'title $name, value: $value',
      name: 'SomeButtonClassI18n_titleWithManyParameter',
      args: [name, value],
    );
  }

  static String titleWithOptionalParameter({String name}) {
    return Intl.message(
      'title $name',
      name: 'SomeButtonClassI18n_titleWithOptionalParameter',
      args: [name],
    );
  }

  static String titleWithManyOptionalParameter({String name, int value}) {
    return Intl.message(
      'title $name, value: $value',
      name: 'SomeButtonClassI18n_titleWithOptionalParameter',
      args: [name, value],
    );
  }

  static String titleWithPositionParameter([String name]) {
    return Intl.message(
      'title $name',
      name: 'SomeButtonClassI18n_titleWithPositionParameter',
      args: [name],
    );
  }

  static String titleWithManyPositionParameter([String name, int value]) {
    return Intl.message(
      'title $name, value: $value',
      name: 'SomeButtonClassI18n_titleWithManyPositionParameter',
      args: [name, value],
    );
  }
}
''';

void main() {
  test('PreferIntlArgsRule reports about not found issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
      content: _content,
      // ignore: deprecated_member_use
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    final issues =
        ProvideCorrectIntlArgsRule().check(InternalResolvedUnitResult(
      sourceUrl,
      parseResult.content,
      parseResult.unit,
    ));

    expect(issues, isEmpty);
  });
}
