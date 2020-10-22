@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/models/source.dart';
import 'package:dart_code_metrics/src/rules/provide_correct_intl_args.dart';
import 'package:test/test.dart';

const _content = r"""
import 'package:intl/intl.dart';    
//Issues

class SomeButtonClassI18n {
  static const int value = 0;
  static const String name = 'name';

  static String simpleTitleNotExistArgsIssue(String name) {
    return Intl.message(
      'title',
      name: 'SomeButtonClassI18n_simpleTitleNotExistArgsIssue',
    );
  }
  
  static String simpleTitleArgsMustBeOmittedIssue1() {
    return Intl.message(
      'title $name',
      name: 'SomeButtonClassI18n_simpleTitleArgsMustBeOmittedIssue1',
      args:  [name]
    );
  }  
  
  static String simpleTitleArgsMustBeOmittedIssue2() {
    return Intl.message(
      'title',
      name: 'SomeButtonClassI18n_simpleTitleArgsMustBeOmittedIssue2',
      args:  [name]
    );
  }  
  
  static String simpleArgsItemMustBeOmittedIssue(int value) {
    return Intl.message(
      'title $value',
      name: 'SomeButtonClassI18n_simpleArgsItemMustBeOmittedIssue',
      args:  [value, name]
    );
  }  
  
  static String simpleParameterMustBeOmittedIssue(String name, int value) {
    return Intl.message(
      'title $value',
      name: 'SomeButtonClassI18n_simpleParameterMustBeOmittedIssue',
      args:  [value, name]
    );
  }  
  
  static String simpleMustBeSimpleIdentifierIssue1(int value) {
    return Intl.message(
      'title ${value+1}',
      name: 'SomeButtonClassI18n_simpleMustBeSimpleIdentifierIssue1',
      args:  [value]
    );
  }  
  
  static String simpleMustBeSimpleIdentifierIssue2(int value) {
    return Intl.message(
      'title $value',
      name: 'SomeButtonClassI18n_simpleMustBeSimpleIdentifierIssue2',
      args:  [value+1]
    );
  }  
  
  static String simpleParameterMustBeInArgsIssue(int value, String name) {
    return Intl.message(
      'title $value, name: $name',
      name: 'SomeButtonClassI18n_simpleParameterMustBeInArgsIssue',
      args:  [value]
    );
  }
  
  static String simpleArgsMustBeInParameterIssue(int value) {
    return Intl.message(
      'title $value, name: $name',
      name: 'SomeButtonClassI18n_simpleArgsMustBeInParameterIssue',
      args:  [value, name]
    );
  }
  
  static String simpleInterpolationMustBeInArgsIssue(int value, String name) {
    return Intl.message(
      'title $value, name: $name',
      name: 'SomeButtonClassI18n_simpleInterpolationMustBeInArgsIssue',
      args:  [value]
    );
  }
  
  static String simpleInterpolationMustBeInParameterIssue(int value) {
    return Intl.message(
      'title $value, name: $name',
      name: 'SomeButtonClassI18n_simpleInterpolationMustBeInParameterIssue',
      args:  [value, name]
    );
  } 
}
""";

void main() {
  test('PreferIntlArgsRule reports about not found issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
        content: _content,
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false);

    final issues = ProvideCorrectIntlArgsRule()
        .check(Source(sourceUrl, parseResult.content, parseResult.unit));

    expect(issues.length, equals(22));

    expect(issues.every((issue) => issue.ruleId == 'provide-correct-intl-args'),
        isTrue);

    expect(issues.every((issue) => issue.severity == CodeIssueSeverity.warning),
        isTrue);

    expect(
      issues.map((issue) => issue.message),
      equals([
        'Parameter "args" should be added',
        'Parameter should be added to args',
        'Parameter is unused and should be removed',
        'Item is unused and should be removed',
        'Parameter "args" should be removed',
        'Args item should be added to parameters',
        'Interpolation expression should be added to parameters',
        'Parameter "args" should be removed',
        'Args item should be added to parameters',
        'Args item should be added to parameters',
        'Item should be simple identifier',
        'Item should be simple identifier',
        'Parameter should be added to args',
        'Interpolation expression should be added to args',
        'Parameter should be added to args',
        'Interpolation expression should be added to args',
        'Args item should be added to parameters',
        'Interpolation expression should be added to parameters',
        'Parameter should be added to args',
        'Interpolation expression should be added to args',
        'Args item should be added to parameters',
        'Interpolation expression should be added to parameters',
      ]),
    );

    expect(issues.every((issue) => issue.correction == null), isTrue);
    expect(issues.every((issue) => issue.correctionComment == null), isTrue);

    expect(issues.every((issue) => issue.sourceSpan.sourceUrl == sourceUrl),
        isTrue);

    expect(
        issues.map((issue) => issue.sourceSpan.text),
        equals([
          '(String name)',
          'name',
          'name',
          'name',
          '[name]',
          'name',
          'name',
          '[name]',
          'name',
          'name',
          'value+1',
          'value+1',
          'value',
          'value',
          'name',
          'name',
          'name',
          'name',
          'name',
          'name',
          'name',
          'name',
        ]));

    expect(
        issues.map((issue) => issue.sourceSpan.start.offset),
        equals([
          187,
          195,
          195,
          195,
          505,
          506,
          415,
          706,
          707,
          927,
          1288,
          1601,
          1461,
          1509,
          1693,
          1754,
          2075,
          1979,
          2166,
          2227,
          2570,
          2465,
        ]));
    expect(
        issues.map((issue) => issue.sourceSpan.start.line),
        equals([
          8,
          8,
          8,
          8,
          19,
          19,
          17,
          27,
          27,
          35,
          49,
          59,
          55,
          57,
          63,
          65,
          75,
          73,
          79,
          81,
          91,
          89,
        ]));
    expect(
        issues.map((issue) => issue.sourceSpan.start.column),
        equals([
          45,
          53,
          53,
          53,
          14,
          15,
          15,
          14,
          15,
          22,
          16,
          15,
          56,
          15,
          68,
          29,
          22,
          29,
          72,
          29,
          22,
          29,
        ]));

    expect(
        issues.map((issue) => issue.sourceSpan.end.offset),
        equals([
          200,
          199,
          199,
          199,
          511,
          510,
          419,
          712,
          711,
          931,
          1295,
          1608,
          1466,
          1514,
          1697,
          1758,
          2079,
          1983,
          2170,
          2231,
          2574,
          2469,
        ]));
    expect(
        issues.map((issue) => issue.sourceSpan.end.line),
        equals([
          8,
          8,
          8,
          8,
          19,
          19,
          17,
          27,
          27,
          35,
          49,
          59,
          55,
          57,
          63,
          65,
          75,
          73,
          79,
          81,
          91,
          89,
        ]));
    expect(
        issues.map((issue) => issue.sourceSpan.end.column),
        equals([
          58,
          57,
          57,
          57,
          20,
          19,
          19,
          20,
          19,
          26,
          23,
          22,
          61,
          20,
          72,
          33,
          26,
          33,
          76,
          33,
          26,
          33,
        ]));
  });
}
