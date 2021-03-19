@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/no_equal_arguments.dart';
import 'package:test/test.dart';

// ignore_for_file: no_adjacent_strings_in_list

const _content = '''

class User {
  final String firstName;
  final String lastName;

  const User(this.firstName, this.lastName);

  String getName => firstName;

  String getFirstName() => firstName;

  String getNewName(String name) => firstName + name;
}

User createUser(String firstName, String lastName)  {
  return User(
    firstName,
    firstName,
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
    user.firstName,
  );

  final fullName = getFullName(
    user.getName,
    user.getName,
  );

  final fullName = getFullName(
    user.getFirstName(),
    user.getFirstName(),
  );

  final fullName = getFullName(
    user.getNewName('name'),
    user.getNewName('name'),
  );

  final name = 'name';

  final fullName = getFullName(
    user.getNewName(name),
    user.getNewName(name),
  );

  final image = getUserImage(
    firstName: user.firstName,
    lastName: user.firstName,
  );
}

''';

const _correctContent = '''

class User {
  final String firstName;
  final String lastName;

  const User(this.firstName, this.lastName);

  String getName => firstName;

  String getFirstName() => firstName;

  String getLastName() => lastName;

  String getNewName(String name) => firstName + name;
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

  String getUserImage({String firstName, String lastName}) {
    return '/test_url/' + firstName ?? '' + lastName ?? '';
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

''';

void main() {
  group('NoEqualArguments', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
      content: _content,
      // ignore: deprecated_member_use
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    test('initialization', () {
      final issues = NoEqualArguments().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.every((issue) => issue.ruleId == 'no-equal-arguments'),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.severity == Severity.warning),
        isTrue,
      );
    });

    test('reports about found issues', () {
      final issues = NoEqualArguments().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.map((issue) => issue.location.start.offset),
        equals([328, 661, 737, 818, 910, 1028, 1122]),
      );
      expect(
        issues.map((issue) => issue.location.start.line),
        equals([18, 33, 38, 43, 48, 55, 60]),
      );
      expect(
        issues.map((issue) => issue.location.start.column),
        equals([5, 5, 5, 5, 5, 5, 5]),
      );
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals([337, 675, 749, 837, 933, 1049, 1146]),
      );
      expect(
        issues.map((issue) => issue.location.text),
        equals([
          'firstName',
          'user.firstName',
          'user.getName',
          'user.getFirstName()',
          "user.getNewName('name')",
          'user.getNewName(name)',
          'lastName: user.firstName',
        ]),
      );
      expect(
        issues.map((issue) => issue.message),
        equals([
          'The argument has already been passed',
          'The argument has already been passed',
          'The argument has already been passed',
          'The argument has already been passed',
          'The argument has already been passed',
          'The argument has already been passed',
          'The argument has already been passed',
        ]),
      );
    });

    test('reports about no found issues', () {
      final parseResult = parseString(
        content: _correctContent,
        // ignore: deprecated_member_use
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false,
      );

      final issues = NoEqualArguments().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(issues.isEmpty, isTrue);
    });
  });
}
