# Avoid missing enum constant in map

## Rule id {#rule-id}

avoid-missing-enum-constant-in-map

## Severity {#severity}

Warning

## Description {#description}

Warns when a enum constant is missing in a map declaration.

### Example {#example}

Bad:

```dart
enum SomeEnum {
  firstEntry,
  secondEntry,
  thirdEntry,
}

extension SomeX on SomeEnum {
  // LINT
  static const firstMap = <SomeEnum, String>{
    CountyCode.firstEntry: 'foo',
    CountyCode.secondEntry: 'bar',
  };

  // LINT twice since `secondEntry` and `thirdEntry` are missing
  static const secondMap = <SomeEnum, String>{
    CountyCode.firstEntry: 'foo',
  };
}
```

Good:

```dart
enum SomeEnum {
  firstEntry,
  secondEntry,
  thirdEntry,
}

extension SomeX on SomeEnum {
  static const firstMap = <SomeEnum, String>{
    CountyCode.firstEntry: 'foo',
    CountyCode.secondEntry: 'bar',
    CountyCode.thirdEntry: 'baz',
  };

  static const secondMap = <SomeEnum, String>{
    CountyCode.firstEntry: 'foo',
    CountyCode.secondEntry: 'bar',
    CountyCode.thirdEntry: 'baz',
  };
}
```
