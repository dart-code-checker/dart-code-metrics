# No equal arguments

![Configurable](https://img.shields.io/badge/-configurable-informational)

## Rule id

no-equal-arguments

## Description

Warns when equal arguments passed to a function or method invocation.

Use `ignored-parameters` configuration, if you want to ignore specific named parameters.

### Config example

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - no-equal-arguments:
        ignored-parameters:
          - height
          - width
```

### Example

Bad:

```dart
class User {
  final String firstName;
  final String lastName;

  const User(this.firstName, this.lastName);
}

User createUser(String firstName, String lastName)  {
  return User(
    firstName,
    firstName, // LINT
  );
}

void getUserData(User user) {
  String getFullName(String firstName, String lastName) {
    return firstName + ' ' + lastName;
  }

  final fullName = getFullName(
    user.firstName,
    user.firstName, // LINT
  );
}
```

Good:

```dart
class User {
  final String firstName;
  final String lastName;

  const User(this.firstName, this.lastName);
}

User createUser(String firstName, String lastName)  {
  return User(
    firstName,
    lastName,
  );
}

void getUserData(User user) {
  String getFullName(String firstName, String lastName) {
    return firstName + ' ' + lastName;
  }

  final fullName = getFullName(
    user.firstName,
    user.lastName,
  );
}
```
