# No equal arguments

## Rule id

no-equal-arguments

## Description

Warns when equal arguments passed to function or method invocations.

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
    firstName, // <--
  );
}

void getUserData(User user) {
  String getFullName(String firstName, String lastName) {
    return firstName + ' ' + lastName;
  }

  final fullName = getFullName(
    user.firstName,
    user.firstName, // <--
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
