@TestOn('vm')
import 'package:dart_code_metrics/src/models/severity.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/prefer_intl_name.dart';
import 'package:test/test.dart';

import '../../../helpers/rule_test_helper.dart';

const _examplePath =
    'test/obsoleted/rules/prefer_intl_name/examples/example.dart';
const _incorrectExamplePath =
    'test/obsoleted/rules/prefer_intl_name/examples/incorrect_example.dart';
const _notExistingExamplePath =
    'test/obsoleted/rules/prefer_intl_name/examples/not_existing_example.dart';

void main() {
  group('PreferIntlNameRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferIntlNameRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-intl-name',
        severity: Severity.warning,
      );
    });

    test('reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferIntlNameRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports about found issues for incorrect names', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = PreferIntlNameRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [
          184,
          354,
          562,
          771,
          968,
          1161,
          1328,
          1494,
          1654,
          1837,
          2008,
          2175,
          2408,
          2578,
          2764,
          2973,
          3170,
          3363,
          3552,
          3696,
          3856,
          4039,
          4210,
          4377,
          4634,
          4860,
          5068,
          5272,
          5476,
          5670,
          5852,
          6030,
          6181,
          6272,
          6379,
          6509,
          6627,
          6741,
        ],
        startLines: [
          7,
          13,
          20,
          26,
          32,
          38,
          44,
          51,
          57,
          63,
          69,
          75,
          84,
          90,
          96,
          102,
          108,
          114,
          121,
          127,
          133,
          139,
          145,
          151,
          160,
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
        ],
        startColumns: [
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
          15,
          13,
          15,
          11,
          11,
          13,
          15,
          13,
          15,
          13,
          15,
          13,
          15,
          13,
          15,
          13,
          15,
          9,
          9,
          11,
          13,
          11,
          13,
        ],
        endOffsets: [
          229,
          394,
          613,
          828,
          1013,
          1212,
          1367,
          1528,
          1699,
          1888,
          2047,
          2220,
          2453,
          2618,
          2815,
          3030,
          3215,
          3414,
          3591,
          3730,
          3901,
          4090,
          4249,
          4422,
          4687,
          4919,
          5115,
          5325,
          5523,
          5723,
          5893,
          6077,
          6193,
          6279,
          6397,
          6533,
          6639,
          6759,
        ],
        locationTexts: [
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
        ],
        messages: issues.map((issue) =>
            'Incorrect Intl name, should be ${issue.suggestion!.replacement}'),
        replacements: [
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
        ],
        replacementComments: issues.map((_) => 'Rename'),
      );
    });

    test('reports about found issues for not existing names', () async {
      final unit =
          await RuleTestHelper.resolveFromFile(_notExistingExamplePath);
      final issues = PreferIntlNameRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [
          139,
          258,
          397,
          531,
          667,
          791,
          917,
          1016,
          1135,
          1249,
          1365,
          1469,
          1631,
          1750,
          1889,
          2023,
          2159,
          2283,
          2409,
          2508,
          2627,
          2741,
          2857,
          2961,
          3156,
          3301,
          3434,
          3580,
          3705,
          3818,
          3922,
          3997,
          4090,
          4180,
          4272,
          4352,
        ],
        startLines: [
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
          155,
          160,
          165,
          170,
          176,
          181,
          186,
          191,
        ],
        startColumns: [
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
          12,
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
        ],
        endOffsets: [
          146,
          265,
          404,
          538,
          674,
          798,
          924,
          1023,
          1142,
          1256,
          1372,
          1476,
          1638,
          1757,
          1896,
          2030,
          2166,
          2290,
          2416,
          2515,
          2634,
          2748,
          2864,
          2968,
          3163,
          3308,
          3441,
          3587,
          3712,
          3825,
          3929,
          4004,
          4097,
          4187,
          4279,
          4359,
        ],
        locationTexts: issues.map((_) => 'message'),
        messages: issues.map((_) => 'Argument `name` does not exists'),
      );
    });
  });
}
