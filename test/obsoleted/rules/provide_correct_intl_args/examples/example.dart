import 'package:intl/intl.dart';

class SomeButtonClassI18n {
  static String simpleTitle() {
    return Intl.message(
      'title',
      name: 'SomeButtonClassI18n_simpleTitle',
    );
  }

  static String sourceTitle(String source, String openTag, String closeTag) =>
      Intl.message(
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
