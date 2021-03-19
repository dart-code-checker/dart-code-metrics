@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/prefer_intl_name.dart';
import 'package:test/test.dart';

const _content = '''
import 'package:intl/intl.dart';    
//Issues

class SomeButtonClassI18n {
// Static
  static final String staticFinalFieldInClassTitle = Intl.message(
    'static final field in class',
    name: 'SomeButtonClassI18n_staticFinalFieldInClass',
    args: <Object>[],
  );

  static String staticFieldInClassTitle = Intl.message(
    'static field in class',
    name: 'SomeButtonClassI18n_staticFieldInClass',
    args: <Object>[],
  );

  static String get staticPropertyWithBodyInClassTitle {
    return Intl.message(
      'static property with body in class',
      name: 'SomeButtonClassI18n_staticPropertyWithBodyInClass',
    );
  }

  static String get staticPropertyWithExpressionInClassTitle => Intl.message(
        'static property with expression in class',
        name: 'SomeButtonClassI18n_staticPropertyWithExpressionInClass',
      );

  static String staticMethodBodyInClassTitle() {
    return Intl.message(
      'static method with body in class',
      name: 'SomeButtonClassI18n_staticMethodBodyInClass',
    );
  }

  static String staticMethodExpressionInClassTitle() => Intl.message(
        'static method with expression in class',
        name: 'SomeButtonClassI18n_staticMethodExpressionInClass',
      );

// Instance
  final String finalFieldInClassTitle = Intl.message(
    'final field in class',
    name: 'SomeButtonClassI18n_finalFieldInClass',
    args: <Object>[],
  );

  String fieldInClassTitle = Intl.message(
    'field in class',
    args: <Object>[],
    name: 'SomeButtonClassI18n_fieldInClass',
  );

  String get propertyWithBodyInClassTitle {
    return Intl.message(
      'property with body in class',
      name: 'SomeButtonClassI18n_propertyWithBodyInClass',
    );
  }

  String get propertyWithExpressionInClassTitle => Intl.message(
        'property with expression in class',
        name: 'SomeButtonClassI18n_propertyWithExpressionInClass',
      );

  String methodBodyInClassTitle() {
    return Intl.message(
      'method with body in class',
      name: 'SomeButtonClassI18n_methodBodyInClass',
    );
  }

  String methodExpressionInClassTitle() => Intl.message(
        'method with expression in class',
        name: 'SomeButtonClassI18n_methodExpressionInClass',
      );
}

mixin SomeButtonMixinI18n {
  // Static
  static final String staticFinalFieldInMixinTitle = Intl.message(
    'static final field in mixin',
    args: <Object>[],
    name: 'SomeButtonMixinI18n_staticFinalFieldInMixin',
  );

  static String staticFieldInMixinTitle = Intl.message(
    'static field in mixin',
    args: <Object>[],
    name: 'SomeButtonMixinI18n_staticFieldInMixin',
  );

  static String get staticPropertyWithBodyInMixinTitle {
    return Intl.message(
      'static property with body in mixin',
      name: 'SomeButtonMixinI18n_staticPropertyWithBodyInMixin',
    );
  }

  static String get staticPropertyWithExpressionInMixinTitle => Intl.message(
    'static property with expression in mixin',
    name: 'SomeButtonMixinI18n_staticPropertyWithExpressionInMixin',
  );

  static String staticMethodBodyInMixinTitle() {
    return Intl.message(
      'static method with body in mixin',
      name: 'SomeButtonMixinI18n_staticMethodBodyInMixin',
    );
  }

  static String staticMethodExpressionInMixinTitle() => Intl.message(
    'static method with expression in mixin',
    name: 'SomeButtonMixinI18n_staticMethodExpressionInMixin',
  );

// Instance
  final String finalFieldInMixinTitle = Intl.message(
    'final field in mixin',
    args: <Object>[],
    name: 'SomeButtonMixinI18n_finalFieldInMixin',
  );

  String fieldInMixinTitle = Intl.message(
    'field in mixin',
    args: <Object>[],
    name: 'SomeButtonMixinI18n_fieldInMixin',
  );

  String get propertyWithBodyInMixinTitle {
    return Intl.message(
      'property with body in mixin',
      name: 'SomeButtonMixinI18n_propertyWithBodyInMixin',
    );
  }

  String get propertyWithExpressionInMixinTitle => Intl.message(
    'property with expression in mixin',
    name: 'SomeButtonMixinI18n_propertyWithExpressionInMixin',
  );

  String methodBodyInMixinTitle() {
    return Intl.message(
      'method with body in mixin',
      name: 'SomeButtonMixinI18n_methodBodyInMixin',
    );
  }

  String methodExpressionInMixinTitle() => Intl.message(
    'method with expression in mixin',
    name: 'SomeButtonMixinI18n_methodExpressionInMixin',
  );
}

extension ObjectExtensions on Object {
  // Static
  static String get staticPropertyWithBodyInExtensionsTitle {
    return Intl.message(
      'static property with body in extension',
      name: 'ObjectExtensions_staticPropertyWithBodyInExtensions',
    );
  }

  static String get staticPropertyWithExpressionInExtensionsTitle => Intl.message(
    'static property with expression in extension',
    name: 'ObjectExtensions_staticPropertyWithExpressionInExtensions',
  );

  static String staticMethodBodyInExtensionsTitle() {
    return Intl.message(
      'static method with body in extension',
      name: 'ObjectExtensions_staticMethodBodyInExtensions',
    );
  }

  static String staticMethodExpressionInExtensionsTitle() => Intl.message(
    'static method with expression in extension',
    name: 'ObjectExtensions_staticMethodExpressionInExtensions',
  );

// Instance
  String get propertyWithBodyInExtensionsTitle {
    return Intl.message(
      'property with body in extension',
      name: 'ObjectExtensions_propertyWithBodyInExtensions',
    );
  }

  String get propertyWithExpressionInExtensionsTitle => Intl.message(
    'property with expression in extension',
    name: 'ObjectExtensions_propertyWithExpressionInExtensions',
  );

  String methodBodyInExtensionsTitle() {
    return Intl.message(
      'method with body in extension',
      name: 'ObjectExtensions_methodBodyInExtensions',
    );
  }

  String methodExpressionInExtensionsTitle() => Intl.message(
    'method with expression in extension',
    name: 'ObjectExtensions_methodExpressionInExtensions',
  );
}

final String finalFieldTitle = Intl.message(
  'final field',
  args: <Object>[],
  name: 'finalField',
);

String fieldTitle = Intl.message(
  'field',
  args: <Object>[],
  name: 'field',
);

String get propertyWithBodyTitle {
  return Intl.message(
    'property with body',
    name: 'propertyWithBody',
  );
}

String get propertyWithExpressionTitle => Intl.message(
  'property with expression',
  name: 'propertyWithExpression',
);

String methodBodyTitle() {
  return Intl.message(
    'method with body',
    name: 'methodBody',
  );
}

String methodExpressionTitle() => Intl.message(
  'method with expression',
  name: 'methodExpression',
);
''';

void main() {
  test('PreferIntlNameRule reports about found not correct name issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
      content: _content,
      // ignore: deprecated_member_use
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    final issues = PreferIntlNameRule().check(InternalResolvedUnitResult(
      sourceUrl,
      parseResult.content,
      parseResult.unit,
    ));

    expect(issues, hasLength(38));

    expect(issues.every((issue) => issue.ruleId == 'prefer-intl-name'), isTrue);

    expect(
      issues.every((issue) => issue.severity == Severity.warning),
      isTrue,
    );

    expect(
      issues.map((issue) => issue.message),
      equals(issues.map((issue) =>
          'Incorrect Intl name, should be ${issue.suggestion.replacement}')),
    );

    expect(
      issues.map((issue) => issue.suggestion.replacement),
      equals([
        "'SomeButtonClassI18n_staticFinalFieldInClassTitle'",
        "'SomeButtonClassI18n_staticFieldInClassTitle'",
        "'SomeButtonClassI18n_staticPropertyWithBodyInClassTitle'",
        "'SomeButtonClassI18n_staticPropertyWithExpressionInClassTitle'",
        "'SomeButtonClassI18n_staticMethodBodyInClassTitle'",
        "'SomeButtonClassI18n_staticMethodExpressionInClassTitle'",
        "'SomeButtonClassI18n_finalFieldInClassTitle'",
        "'SomeButtonClassI18n_fieldInClassTitle'",
        "'SomeButtonClassI18n_propertyWithBodyInClassTitle'",
        "'SomeButtonClassI18n_propertyWithExpressionInClassTitle'",
        "'SomeButtonClassI18n_methodBodyInClassTitle'",
        "'SomeButtonClassI18n_methodExpressionInClassTitle'",
        "'SomeButtonMixinI18n_staticFinalFieldInMixinTitle'",
        "'SomeButtonMixinI18n_staticFieldInMixinTitle'",
        "'SomeButtonMixinI18n_staticPropertyWithBodyInMixinTitle'",
        "'SomeButtonMixinI18n_staticPropertyWithExpressionInMixinTitle'",
        "'SomeButtonMixinI18n_staticMethodBodyInMixinTitle'",
        "'SomeButtonMixinI18n_staticMethodExpressionInMixinTitle'",
        "'SomeButtonMixinI18n_finalFieldInMixinTitle'",
        "'SomeButtonMixinI18n_fieldInMixinTitle'",
        "'SomeButtonMixinI18n_propertyWithBodyInMixinTitle'",
        "'SomeButtonMixinI18n_propertyWithExpressionInMixinTitle'",
        "'SomeButtonMixinI18n_methodBodyInMixinTitle'",
        "'SomeButtonMixinI18n_methodExpressionInMixinTitle'",
        "'ObjectExtensions_staticPropertyWithBodyInExtensionsTitle'",
        "'ObjectExtensions_staticPropertyWithExpressionInExtensionsTitle'",
        "'ObjectExtensions_staticMethodBodyInExtensionsTitle'",
        "'ObjectExtensions_staticMethodExpressionInExtensionsTitle'",
        "'ObjectExtensions_propertyWithBodyInExtensionsTitle'",
        "'ObjectExtensions_propertyWithExpressionInExtensionsTitle'",
        "'ObjectExtensions_methodBodyInExtensionsTitle'",
        "'ObjectExtensions_methodExpressionInExtensionsTitle'",
        "'finalFieldTitle'",
        "'fieldTitle'",
        "'propertyWithBodyTitle'",
        "'propertyWithExpressionTitle'",
        "'methodBodyTitle'",
        "'methodExpressionTitle'",
      ]),
    );

    expect(
      issues.every((issue) => issue.suggestion.comment == 'Rename'),
      isTrue,
    );

    expect(
      issues.every((issue) => issue.location.sourceUrl == sourceUrl),
      isTrue,
    );

    expect(
      issues.map((issue) => issue.location.text),
      equals([
        "'SomeButtonClassI18n_staticFinalFieldInClass'",
        "'SomeButtonClassI18n_staticFieldInClass'",
        "'SomeButtonClassI18n_staticPropertyWithBodyInClass'",
        "'SomeButtonClassI18n_staticPropertyWithExpressionInClass'",
        "'SomeButtonClassI18n_staticMethodBodyInClass'",
        "'SomeButtonClassI18n_staticMethodExpressionInClass'",
        "'SomeButtonClassI18n_finalFieldInClass'",
        "'SomeButtonClassI18n_fieldInClass'",
        "'SomeButtonClassI18n_propertyWithBodyInClass'",
        "'SomeButtonClassI18n_propertyWithExpressionInClass'",
        "'SomeButtonClassI18n_methodBodyInClass'",
        "'SomeButtonClassI18n_methodExpressionInClass'",
        "'SomeButtonMixinI18n_staticFinalFieldInMixin'",
        "'SomeButtonMixinI18n_staticFieldInMixin'",
        "'SomeButtonMixinI18n_staticPropertyWithBodyInMixin'",
        "'SomeButtonMixinI18n_staticPropertyWithExpressionInMixin'",
        "'SomeButtonMixinI18n_staticMethodBodyInMixin'",
        "'SomeButtonMixinI18n_staticMethodExpressionInMixin'",
        "'SomeButtonMixinI18n_finalFieldInMixin'",
        "'SomeButtonMixinI18n_fieldInMixin'",
        "'SomeButtonMixinI18n_propertyWithBodyInMixin'",
        "'SomeButtonMixinI18n_propertyWithExpressionInMixin'",
        "'SomeButtonMixinI18n_methodBodyInMixin'",
        "'SomeButtonMixinI18n_methodExpressionInMixin'",
        "'ObjectExtensions_staticPropertyWithBodyInExtensions'",
        "'ObjectExtensions_staticPropertyWithExpressionInExtensions'",
        "'ObjectExtensions_staticMethodBodyInExtensions'",
        "'ObjectExtensions_staticMethodExpressionInExtensions'",
        "'ObjectExtensions_propertyWithBodyInExtensions'",
        "'ObjectExtensions_propertyWithExpressionInExtensions'",
        "'ObjectExtensions_methodBodyInExtensions'",
        "'ObjectExtensions_methodExpressionInExtensions'",
        "'finalField'",
        "'field'",
        "'propertyWithBody'",
        "'propertyWithExpression'",
        "'methodBody'",
        "'methodExpression'",
      ]),
    );

    expect(
      issues.map((issue) => issue.location.start.offset),
      equals([
        197,
        367,
        575,
        784,
        981,
        1174,
        1341,
        1507,
        1667,
        1850,
        2021,
        2188,
        2421,
        2591,
        2777,
        2978,
        3171,
        3356,
        3541,
        3685,
        3845,
        4020,
        4187,
        4346,
        4599,
        4811,
        5015,
        5211,
        5411,
        5597,
        5775,
        5945,
        6092,
        6183,
        6290,
        6412,
        6526,
        6632,
      ]),
    );
    expect(
      issues.map((issue) => issue.location.start.line),
      equals([
        8,
        14,
        21,
        27,
        33,
        39,
        45,
        52,
        58,
        64,
        70,
        76,
        85,
        91,
        97,
        103,
        109,
        115,
        122,
        128,
        134,
        140,
        146,
        152,
        161,
        167,
        173,
        179,
        186,
        192,
        198,
        204,
        211,
        217,
        223,
        229,
        235,
        241,
      ]),
    );
    expect(
      issues.map((issue) => issue.location.start.column),
      equals([
        11,
        11,
        13,
        15,
        13,
        15,
        11,
        11,
        13,
        15,
        13,
        15,
        11,
        11,
        13,
        11,
        13,
        11,
        11,
        11,
        13,
        11,
        13,
        11,
        13,
        11,
        13,
        11,
        13,
        11,
        13,
        11,
        9,
        9,
        11,
        9,
        11,
        9,
      ]),
    );

    expect(
      issues.map((issue) => issue.location.end.offset),
      equals([
        242,
        407,
        626,
        841,
        1026,
        1225,
        1380,
        1541,
        1712,
        1901,
        2060,
        2233,
        2466,
        2631,
        2828,
        3035,
        3216,
        3407,
        3580,
        3719,
        3890,
        4071,
        4226,
        4391,
        4652,
        4870,
        5062,
        5264,
        5458,
        5650,
        5816,
        5992,
        6104,
        6190,
        6308,
        6436,
        6538,
        6650,
      ]),
    );
    expect(
      issues.map((issue) => issue.location.end.line),
      equals([
        8,
        14,
        21,
        27,
        33,
        39,
        45,
        52,
        58,
        64,
        70,
        76,
        85,
        91,
        97,
        103,
        109,
        115,
        122,
        128,
        134,
        140,
        146,
        152,
        161,
        167,
        173,
        179,
        186,
        192,
        198,
        204,
        211,
        217,
        223,
        229,
        235,
        241,
      ]),
    );
    expect(
      issues.map((issue) => issue.location.end.column),
      equals([
        56,
        51,
        64,
        72,
        58,
        66,
        50,
        45,
        58,
        66,
        52,
        60,
        56,
        51,
        64,
        68,
        58,
        62,
        50,
        45,
        58,
        62,
        52,
        56,
        66,
        70,
        60,
        64,
        60,
        64,
        54,
        58,
        21,
        16,
        29,
        33,
        23,
        27,
      ]),
    );
  });
}
