class User {
  final String firstName;
  final String lastName;

  const User(this.firstName, this.lastName);

  String getName() => firstName;

  String getFirstName() => firstName;

  String getLastName() => lastName;

  String getNewName(String name) => firstName + name;
}

User createUser(String firstName, String lastName) {
  return User(
    firstName,
    lastName,
  );
}

void getUserData(User user) {
  String getFullName(String firstName, String lastName) {
    return firstName + ' ' + lastName;
  }

  String getUserImage({String firstName, String lastName}) {
    return '/test_url/' + firstName! ?? '' + lastName! ?? '';
  }

  final fullName = getFullName(
    user.firstName,
    user.lastName,
  );

  final fullName = getFullName(
    user.getName,
    user.lastName,
  );

  final fullName = getFullName(
    'firstName',
    lastName,
  );

  final fullName = getFullName(
    'firstName',
    'lastName',
  );

  final fullName = getFullName(
    'firstName',
    'firstName',
  );

  final fullName = getFullName(
    user.getFirstName(),
    user.getLastName(),
  );

  final fullName = getFullName(
    user.getNewName('name'),
    user.getNewName('new name'),
  );

  final name = 'name';
  final newName = 'new name';

  final fullName = getFullName(
    user.getNewName(name),
    user.getNewName(newName),
  );

  final image = getUserImage(
    firstName: user.firstName,
    lastName: user.lastName,
  );

  final image = getUserImage(
    firstName: 'name',
    lastName: 'name',
  );
}

int getWidthAndHeight() {
  int calculate(int width, int height) => width + height;

  return calculate(
    -1,
    -1,
  );
}
