part of 'prefer_correct_identifier_length.dart';

class _Validator {
  final int maxLength;
  final int minLength;
  final Iterable<String> exception;

  _Validator(this.maxLength, this.minLength, this.exception);

  bool isValid(SimpleIdentifier identifier) => _validate(identifier.name);

  bool _validate(String name) {
    if (!exception.contains(name) && name.length < minLength) {
      return false;
    } else if (name.length > maxLength) {
      return false;
    } else {
      return true;
    }
  }
}
