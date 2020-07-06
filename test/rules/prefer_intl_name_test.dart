@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/prefer_intl_name.dart';
import 'package:test/test.dart';

const _content = '''
import 'package:intl/intl.dart';    
//Issues

class SomeButtonI18n {
  static final String title1 = Intl.message(
    'One Title',
    name: 'SomeButtonI18n_titleOne'
  );

  final String title2 = Intl.message(
    'Two Title',
    name: 'titleTwo'
  );  

  String get title3 => Intl.message(
    'Three Title',
    name: 'SomeButtonI18n_titleThree'
  );  
  
  static String get title4 => Intl.message(
    'Four Title',
    name: 'SomeButtonI18n_titleFour'
  ); 
  
  String title5() => Intl.message(
    'Five Title',
    name: 'SomeButtonI18n_titleFive'
  );  
  
  static String title6() {
    return Intl.message(
      'Six Title',
      name: 'SomeButtonI18n_titleSix'
     );
  } 
}

String title7() {
  return Intl.message(
    'Seven Title',
    name: 'SomeButtonI18n_titleSeven'
  );
}

String title8() => Intl.message(
  'Eight Title',
  name: 'titleEight'
);
    
String title8() => Intl.message(
  'Eight Title',
);

//Correct

class SomeButtonCorrectI18n {
  static final int number = int.parse('1');

  static final String title1 = Intl.message(
    'One Title',
    name: 'SomeButtonCorrectI18n_title1'
  );

  final String title2 = Intl.message(
    'Two Title',
    name: 'SomeButtonCorrectI18n_title2'
  );  

  String get title3 => Intl.message(
    'Three Title',
    name: 'SomeButtonCorrectI18n_title3'
  );  
  
  static String get title4 => Intl.message(
    'Four Title',
    name: 'SomeButtonCorrectI18n_title4'
  );   

  String get title5 => Intl.message(
    'Three Title',
    name: 'SomeButtonCorrectI18n_title5'
  );  
  
  static String get title6 => Intl.message(
    'Four Title',
    name: 'SomeButtonCorrectI18n_title6'
  ); 
}
  
String title77() {
  return Intl.message(
    'Seven seven Title',
    name: 'title77'
   );
}

String title8() => Intl.message(
  'Eight Title',
  name: 'title8'
);

extension ObjectExtensions on Object {
  String title8() => Intl.message(
    'Eight Title',
    name: 'ObjectExtensions_title8'
  );
}
''';

void main() {
  test('PreferIntlNameRule reports about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
        content: _content,
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false);

    final issues = const PreferIntlNameRule()
        .check(parseResult.unit, sourceUrl, parseResult.content);

    expect(issues.length, equals(8));

    expect(issues.every((issue) => issue.ruleId == 'prefer-intl-name'), isTrue);

    expect(issues.every((issue) => issue.severity == CodeIssueSeverity.warning),
        isTrue);

    expect(
      issues.map((issue) => issue.message),
      equals(issues.map(
          (issue) => 'Incorrect Intl name, should be ${issue.correction}')),
    );

    expect(
      issues.map((issue) => issue.correction),
      equals(List.generate(6, (index) => "'SomeButtonI18n_title${index + 1}'")
        ..add("'title7'")
        ..add("'title8'")),
    );

    expect(
        issues.every((issue) => issue.correctionComment == 'Rename'), isTrue);

    expect(issues.every((issue) => issue.sourceSpan.sourceUrl == sourceUrl),
        isTrue);

    expect(issues.every((issue) => issue.sourceSpan.sourceUrl == sourceUrl),
        isTrue);

    expect(
        issues.map((issue) => issue.sourceSpan.text),
        equals([
          "'SomeButtonI18n_titleOne'",
          "'titleTwo'",
          "'SomeButtonI18n_titleThree'",
          "'SomeButtonI18n_titleFour'",
          "'SomeButtonI18n_titleFive'",
          "'SomeButtonI18n_titleSix'",
          "'SomeButtonI18n_titleSeven'",
          "'titleEight'",
        ]));

    expect(issues.map((issue) => issue.sourceSpan.start.offset),
        equals([142, 239, 324, 434, 533, 653, 765, 859]));
    expect(issues.map((issue) => issue.sourceSpan.start.line),
        equals([7, 12, 17, 22, 27, 33, 41, 47]));
    expect(issues.map((issue) => issue.sourceSpan.start.column),
        equals([11, 11, 11, 11, 11, 13, 11, 9]));

    expect(issues.map((issue) => issue.sourceSpan.end.offset),
        equals([167, 249, 351, 460, 559, 678, 792, 871]));
    expect(issues.map((issue) => issue.sourceSpan.end.line),
        equals([7, 12, 17, 22, 27, 33, 41, 47]));
    expect(issues.map((issue) => issue.sourceSpan.end.column),
        equals([36, 21, 38, 37, 37, 38, 38, 21]));
  });
}
