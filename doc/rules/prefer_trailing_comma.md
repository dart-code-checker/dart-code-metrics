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

### Example

Bad:

```dart
void firstFunction(String arg1, String arg2,
  String arg3) {
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

## Config example

```yaml
prefer-trailing-comma:
  break_on: 2
```
