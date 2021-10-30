# Prefer Intl name

![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

## Rule id {#rule-id}

prefer-intl-name

## Severity {#severity}

Warning

## Description {#description}

Recommends to use `${ClassName}_${ClassMemberName}` pattern for `name` argument in `Intl.message()`, `Intl.plural()`, `Intl.gender()`, `Intl.select()` methods.

### Example {#example}

Bad:

```dart
import 'package:intl/intl.dart';

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
```

Good:

```dart
import 'package:intl/intl.dart';

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
```
