class SomeClassI18n {
  static final String message = Intl.message(
    'message',
    name: 'SomeClassI18n_message',
    desc: 'Message description',
  );

  static String plural = Intl.plural(
    1,
    one: 'one',
    other: 'other',
    name: 'SomeClassI18n_plural',
    desc: 'Plural description',
  );

  static String gender = Intl.gender(
    'other',
    female: 'female',
    male: 'male',
    other: 'other',
    name: 'SomeClassI18n_gender',
    desc: 'Gender description',
  );

  static String select = Intl.select(
    true,
    {true: 'true', false: 'false'},
    name: 'SomeClassI18n_select',
    desc: 'Select description',
  );
}

class Intl {
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
