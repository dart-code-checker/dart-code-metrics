@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/prefer_intl_name.dart';
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
  static String get staticPropertyWithBodyInExtensionsTitle {
    return Intl.message(
      'static property with body in extension',
    );
  }  

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
  String get propertyWithBodyInExtensionsTitle {
    return Intl.message(
      'property with body in extension',
    );
  }  

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
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false);

    final issues = const PreferIntlNameRule()
        .check(parseResult.unit, sourceUrl, parseResult.content);

    expect(issues.length, equals(38));

    expect(issues.every((issue) => issue.ruleId == 'prefer-intl-name'), isTrue);

    expect(issues.every((issue) => issue.severity == CodeIssueSeverity.warning),
        isTrue);

    expect(
      issues.map((issue) => issue.message),
      equals(issues.map((issue) => 'Argument `name` does not exists')),
    );

    expect(issues.every((issue) => issue.correction == null), isTrue);

    expect(issues.every((issue) => issue.correctionComment == null), isTrue);

    expect(issues.every((issue) => issue.sourceSpan.sourceUrl == sourceUrl),
        isTrue);

    expect(issues.every((issue) => issue.sourceSpan.sourceUrl == sourceUrl),
        isTrue);

    expect(issues.every((issue) => issue.sourceSpan.text == 'message'), isTrue);

    expect(
        issues.map((issue) => issue.sourceSpan.start.offset),
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
          3132,
          3277,
          3414,
          3549,
          3691,
          3816,
          3933,
          4048,
          4144,
          4219,
          4312,
          4402,
          4486,
          4566,
        ]));
    expect(
        issues.map((issue) => issue.sourceSpan.start.line),
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
          135,
          140,
          145,
          150,
          156,
          161,
          166,
          171,
          176,
          181,
          187,
          192,
          197,
          202,
        ]));
    expect(
        issues.map((issue) => issue.sourceSpan.start.column),
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
          17,
          75,
          17,
          67,
          17,
          62,
          17,
          54,
          37,
          26,
          15,
          48,
          15,
          40,
        ]));

    expect(
        issues.map((issue) => issue.sourceSpan.end.offset),
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
          3139,
          3284,
          3421,
          3556,
          3698,
          3823,
          3940,
          4055,
          4151,
          4226,
          4319,
          4409,
          4493,
          4573,
        ]));
    expect(
        issues.map((issue) => issue.sourceSpan.end.line),
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
          135,
          140,
          145,
          150,
          156,
          161,
          166,
          171,
          176,
          181,
          187,
          192,
          197,
          202,
        ]));
    expect(
        issues.map((issue) => issue.sourceSpan.end.column),
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
          24,
          82,
          24,
          74,
          24,
          69,
          24,
          61,
          44,
          33,
          22,
          55,
          22,
          47,
        ]));
  });
}
