class User {
  final String firstName;
  final String lastName;

  const User(this.firstName, this.lastName);

  String getName() => firstName;

  String getFirstName() => firstName;

  String getNewName(String name) => firstName + name;
}

User createUser(String firstName, String lastName) {
  return User(
    firstName,
    firstName, // LINT
  );
}

void getUserData(User user) {
  String getFullName(String firstName, String lastName) {
    return firstName + ' ' + lastName;
  }

  String getUserImage({String firstName, String lastName}) {
    return '/test_url/' + firstName ?? '' + lastName ?? '';
  }

  final fullName = getFullName(
    user.firstName,
    user.firstName, // LINT
  );

  final fullName = getFullName(
    user.getName,
    user.getName, // LINT
  );

  final fullName = getFullName(
    user.getFirstName(),
    user.getFirstName(), // LINT
  );

  final fullName = getFullName(
    user.getNewName('name'),
    user.getNewName('name'), // LINT
  );

  final name = 'name';

  final fullName = getFullName(
    user.getNewName(name),
    user.getNewName(name), // LINT
  );

  final image = getUserImage(
    firstName: user.firstName,
    lastName: user.firstName, // LINT
  );
}
