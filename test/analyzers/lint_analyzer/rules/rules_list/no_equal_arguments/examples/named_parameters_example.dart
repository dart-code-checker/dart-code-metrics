String getUserImage({String firstName, String lastName}) {
  return '/test_url/' + firstName ?? '' + lastName ?? '';
}

const firstName = 'name';

final image = getUserImage(
  firstName: firstName,
  lastName: firstName, // LINT
);
