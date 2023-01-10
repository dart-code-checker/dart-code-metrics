class SomeClassI18n {
  static final String message = Intl.message(
    'message',
    name: 'SomeClassI18n_message',
    desc: '',
  );

  static final String message2 = Intl.message(
    'message2',
    name: 'SomeClassI18n_message2',
  );

  static String plural = Intl.plural(
    1,
    one: 'one',
    other: 'other',
    name: 'SomeClassI18n_plural',
    desc: '',
  );

  static String plural2 = Intl.plural(
    2,
    one: 'one',
    other: 'other',
    name: 'SomeClassI18n_plural2',
  );

  static String gender = Intl.gender(
    'other',
    female: 'female',
    male: 'male',
    other: 'other',
    name: 'SomeClassI18n_gender',
    desc: '',
  );

  static String gender2 = Intl.gender(
    'other',
    female: 'female',
    male: 'male',
    other: 'other',
    name: 'SomeClassI18n_gender2',
  );

  static String select = Intl.select(
    true,
    {true: 'true', false: 'false'},
    name: 'SomeClassI18n_select',
    desc: '',
  );

  static String select2 = Intl.select(
    false,
    {true: 'true', false: 'false'},
    name: 'SomeClassI18n_select',
  );
}

class Intl {
  Intl();

  static String message(String messageText,
          {String? desc = '',
          Map<String, Object>? examples,
          String? locale,
          String? name,
          List<Object>? args,
          String? meaning,
          bool? skip}) =>
      '';

  static String plural(num howMany,
          {String? zero,
          String? one,
          String? two,
          String? few,
          String? many,
          required String other,
          String? desc,
          Map<String, Object>? examples,
          String? locale,
          int? precision,
          String? name,
          List<Object>? args,
          String? meaning,
          bool? skip}) =>
      '';

  static String gender(String targetGender,
          {String? female,
          String? male,
          required String other,
          String? desc,
          Map<String, Object>? examples,
          String? locale,
          String? name,
          List<Object>? args,
          String? meaning,
          bool? skip}) =>
      '';

  static String select(Object choice, Map<Object, String> cases,
          {String? desc,
          Map<String, Object>? examples,
          String? locale,
          String? name,
          List<Object>? args,
          String? meaning,
          bool? skip}) =>
      '';
}
