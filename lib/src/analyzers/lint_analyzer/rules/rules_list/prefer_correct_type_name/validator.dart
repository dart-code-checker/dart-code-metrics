part of 'prefer_correct_type_name_rule.dart';

class _Validator {
  final int maxLength;
  final int minLength;
  final Iterable<String> exceptions;

  _Validator({
    required this.maxLength,
    required this.minLength,
    required this.exceptions,
  });

  bool isValid(String name) =>
      name.isEmpty ||
      exceptions.contains(name) ||
      (isUpperCase(name) &&
          withoutUnderscore(name).length >= minLength &&
          withoutUnderscore(name).length <= maxLength);

  bool isUpperCase(String name) {
    final className = withoutUnderscore(name);

    return className[0] == className[0].toUpperCase();
  }

  String withoutUnderscore(String name) =>
      name.startsWith('_') ? name.replaceFirst('_', '') : name;
}
