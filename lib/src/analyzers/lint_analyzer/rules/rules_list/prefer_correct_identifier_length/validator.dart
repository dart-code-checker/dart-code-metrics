part of 'prefer_correct_identifier_length_rule.dart';

class _Validator {
  final int maxLength;
  final int minLength;
  final Iterable<String> exceptions;

  _Validator({
    required this.maxLength,
    required this.minLength,
    required this.exceptions,
  });

  bool isValid(String name) => _validate(_getNameWithoutUnderscore(name));

  bool _validate(String name) =>
      exceptions.contains(name) ||
      (name.length >= minLength && name.length <= maxLength);

  String _getNameWithoutUnderscore(String name) =>
      name.startsWith('_') ? name.replaceFirst('_', '') : name;
}
