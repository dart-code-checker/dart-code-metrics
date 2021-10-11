part of 'prefer_correct_identifier_length.dart';

class _Validator {
  final int maxLength;
  final int minLength;
  final Iterable<String> exceptions;

  _Validator(this.maxLength, this.minLength, this.exceptions);

  bool isValid(SimpleIdentifier identifier) =>
      _validate(_getNameWithoutUnderscore(identifier.name));

  bool _validate(String name) =>
      exceptions.contains(name) ||
      (name.length >= minLength && name.length <= maxLength);

  String _getNameWithoutUnderscore(String name) =>
      name.startsWith('_') ? name.replaceFirst('_', '') : name;
}
