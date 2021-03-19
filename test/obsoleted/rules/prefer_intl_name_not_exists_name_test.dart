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
    args: <Object>[],
  );  
  
  static String staticFieldInClassTitle = Intl.message(
    'static field in class',
    args: <Object>[],
  );

  static String get staticPropertyWithBodyInClassTitle {
    return Intl.message(
      'static property with body in class',
    );
  }  
  
  static String get staticPropertyWithExpressionInClassTitle => Intl.message(
    'static property with expression in class',
  );

  static String staticMethodBodyInClassTitle() {
    return Intl.message(
      'static method with body in class',
     );
  } 
  
  static String staticMethodExpressionInClassTitle() => Intl.message(
    'static method with expression in class',
  );

// Instance
  final String finalFieldInClassTitle = Intl.message(
    'final field in class',
    args: <Object>[],
  );  
  
  String fieldInClassTitle = Intl.message(
    'field in class',
    args: <Object>[],
  );

  String get propertyWithBodyInClassTitle {
    return Intl.message(
      'property with body in class',
    );
  }  
  
  String get propertyWithExpressionInClassTitle => Intl.message(
    'property with expression in class',
  );

  String methodBodyInClassTitle() {
    return Intl.message(
      'method with body in class',
     );
  } 
  
  String methodExpressionInClassTitle() => Intl.message(
    'method with expression in class',
  );
}

mixin SomeButtonMixinI18n {  
  // Static
  static final String staticFinalFieldInMixinTitle = Intl.message(
    'static final field in mixin',
    args: <Object>[],
  );  

  static String staticFieldInMixinTitle = Intl.message(
    'static field in mixin',
    args: <Object>[],
  );

  static String get staticPropertyWithBodyInMixinTitle {
    return Intl.message(
      'static property with body in mixin',
    );
  }  

  static String get staticPropertyWithExpressionInMixinTitle => Intl.message(
    'static property with expression in mixin',
  );

  static String staticMethodBodyInMixinTitle() {
    return Intl.message(
      'static method with body in mixin',
     );
  } 

  static String staticMethodExpressionInMixinTitle() => Intl.message(
    'static method with expression in mixin',
  );

// Instance
  final String finalFieldInMixinTitle = Intl.message(
    'final field in mixin',
    args: <Object>[],
  );  

  String fieldInMixinTitle = Intl.message(
    'field in mixin',
    args: <Object>[],
  );

  String get propertyWithBodyInMixinTitle {
    return Intl.message(
      'property with body in mixin',
    );
  }  

  String get propertyWithExpressionInMixinTitle => Intl.message(
    'property with expression in mixin',
  );

  String methodBodyInMixinTitle() {
    return Intl.message(
      'method with body in mixin',
     );
  } 

  String methodExpressionInMixinTitle() => Intl.message(
    'method with expression in mixin',
  );
}

extension ObjectExtensions on Object {
  // Static
  static String get staticPropertyWithExpressionInExtensionsTitle => Intl.message(
    'static property with expression in extension',
  );

  static String staticMethodBodyInExtensionsTitle() {
    return Intl.message(
      'static method with body in extension',
     );
  } 

  static String staticMethodExpressionInExtensionsTitle() => Intl.message(
    'static method with expression in extension',
  );

// Instance
  String get propertyWithExpressionInExtensionsTitle => Intl.message(
    'property with expression in extension',
  );

  String methodBodyInExtensionsTitle() {
    return Intl.message(
      'method with body in extension',
     );
  } 

  String methodExpressionInExtensionsTitle() => Intl.message(
    'method with expression in extension',
  );
}

final String finalFieldTitle = Intl.message(
  'final field',
  args: <Object>[],
);

String fieldTitle = Intl.message(
  'field',
  args: <Object>[],
);

String get propertyWithBodyTitle {
  return Intl.message(
    'property with body',
  );
}

String get propertyWithExpressionTitle => Intl.message(
  'property with expression',
);

String methodBodyTitle() {
  return Intl.message(
    'method with body',
  );
}

String methodExpressionTitle() => Intl.message(
  'method with expression',
);
''';

void main() {
  test('PreferIntlNameRule reports about found not exists name issues', () {
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

    expect(issues, hasLength(36));

    expect(issues.every((issue) => issue.ruleId == 'prefer-intl-name'), isTrue);

    expect(
      issues.every((issue) => issue.severity == Severity.warning),
      isTrue,
    );

    expect(
      issues.map((issue) => issue.message),
      equals(issues.map((issue) => 'Argument `name` does not exists')),
    );

    expect(issues.every((issue) => issue.suggestion == null), isTrue);

    expect(
      issues.every((issue) => issue.location.sourceUrl == sourceUrl),
      isTrue,
    );

    expect(
      issues.every((issue) => issue.location.sourceUrl == sourceUrl),
      isTrue,
    );

    expect(issues.every((issue) => issue.location.text == 'message'), isTrue);

    expect(
      issues.map((issue) => issue.location.start.offset),
      equals([
        143,
        266,
        405,
        543,
        671,
        799,
        917,
        1020,
        1139,
        1257,
        1365,
        1473,
        1629,
        1750,
        1889,
        2025,
        2153,
        2279,
        2397,
        2498,
        2617,
        2733,
        2841,
        2947,
        3128,
        3265,
        3400,
        3538,
        3655,
        3770,
        3866,
        3941,
        4034,
        4124,
        4208,
        4288,
      ]),
    );
    expect(
      issues.map((issue) => issue.location.start.line),
      equals([
        6,
        11,
        17,
        22,
        27,
        32,
        37,
        42,
        48,
        53,
        58,
        63,
        70,
        75,
        81,
        86,
        91,
        96,
        101,
        106,
        112,
        117,
        122,
        127,
        134,
        139,
        144,
        149,
        154,
        159,
        164,
        169,
        175,
        180,
        185,
        190,
      ]),
    );
    expect(
      issues.map((issue) => issue.location.start.column),
      equals([
        59,
        48,
        17,
        70,
        17,
        62,
        46,
        35,
        17,
        57,
        17,
        49,
        59,
        48,
        17,
        70,
        17,
        62,
        46,
        35,
        17,
        57,
        17,
        49,
        75,
        17,
        67,
        62,
        17,
        54,
        37,
        26,
        15,
        48,
        15,
        40,
      ]),
    );

    expect(
      issues.map((issue) => issue.location.end.offset),
      equals([
        150,
        273,
        412,
        550,
        678,
        806,
        924,
        1027,
        1146,
        1264,
        1372,
        1480,
        1636,
        1757,
        1896,
        2032,
        2160,
        2286,
        2404,
        2505,
        2624,
        2740,
        2848,
        2954,
        3135,
        3272,
        3407,
        3545,
        3662,
        3777,
        3873,
        3948,
        4041,
        4131,
        4215,
        4295,
      ]),
    );
    expect(
      issues.map((issue) => issue.location.end.line),
      equals([
        6,
        11,
        17,
        22,
        27,
        32,
        37,
        42,
        48,
        53,
        58,
        63,
        70,
        75,
        81,
        86,
        91,
        96,
        101,
        106,
        112,
        117,
        122,
        127,
        134,
        139,
        144,
        149,
        154,
        159,
        164,
        169,
        175,
        180,
        185,
        190,
      ]),
    );
    expect(
      issues.map((issue) => issue.location.end.column),
      equals([
        66,
        55,
        24,
        77,
        24,
        69,
        53,
        42,
        24,
        64,
        24,
        56,
        66,
        55,
        24,
        77,
        24,
        69,
        53,
        42,
        24,
        64,
        24,
        56,
        82,
        24,
        74,
        69,
        24,
        61,
        44,
        33,
        22,
        55,
        22,
        47,
      ]),
    );
  });
}
