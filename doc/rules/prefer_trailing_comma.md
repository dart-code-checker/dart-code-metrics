# Prefer trailing comma

![Configurable](https://img.shields.io/badge/-configurable-informational)
![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

## Rule id

prefer-trailing-comma

## Description

Check for trailing comma for arguments, parameters, enum values and collections.
By default warns in cases when items aren't on a single line.

Can be configured by `break_on` parameter, which additionally enables checks for given amount of items.
For example, if `break_on` is equal 2, then the rule also warns for all functions with 2 or more arguments (if they have no trailing comma).

Note: if the last item starts on the same line as opening bracket and ends on the same line as closing, the rule will not warn about this case.

```dart
function('some string', () {
  return;
});
```

Use `break_on` configuration, if you want to override the default behavior.

### Config example

```yaml
prefer-trailing-comma:
  break_on: 2
```

### Example

Bad:

```dart
void firstFunction(
    String firstArgument, String secondArgument, String thirdArgument) {
  return;
}

void secondFunction() {
  firstFunction('some string', 'some other string',
      'and another string for length exceed');
}

void thirdFunction(String someLongVarName, void Function() someLongCallbackName,
    String arg3) {}

class TestClass {
  void firstMethod(
      String firstArgument, String secondArgument, String thirdArgument) {
    return;
  }

  void secondMethod() {
    firstMethod('some string', 'some other string',
        'and another string for length exceed');

    thirdFunction('some string', () {
      return;
    }, 'some other string');
  }
}

final secondArray = [
  'some string',
  'some other string',
  'and another string for length exceed'
];

final secondSet = {
  'some string',
  'some other string',
  'and another string for length exceed'
};

final secondMap = {
  'some string': 'and another string for length exceed',
  'and another string for length exceed': 'and another string for length exceed'
};
```

Good:

```dart
void firstFunction(
  String firstArgument,
  String secondArgument,
  String thirdArgument,
) {
  return;
}

void secondFunction(String arg1) {
  firstFunction(
    'some string',
    'some other string',
    'and another string for length exceed'
  );
}

void thirdFunction(String arg1, void Function() callback) {}

void forthFunction(void Function() callback) {}

class TestClass {
  void firstMethod(
    String firstArgument,
    String secondArgument,
    String thirdArgument,
  ) {
    return;
  }

  void secondMethod() {
    firstMethod(
      'some string',
      'some other string',
      'and another string for length exceed',
    );

    thirdFunction('', () {
      return;
    });

    forthFunction(() {
      return;
    });
  }
}
```

With given config:

```
- break_on: 2
```

Bad:

```dart
void firstFunction(String arg1, String arg2,
  String arg3) {
  return;
}

void secondFunction(String arg1, String arg2, String arg3) {
  return;
}
```

Good:

```dart
void firstFunction(
  String arg1,
  String arg2,
  String arg3,
) {
  return;
}

void secondFunction(
  String arg1,
  String arg2,
  String arg3,
) {
  return;
}

enum FirstEnum { firstItem }

const instance = FirstClass(
  0,
  0,
  0,
);
```
