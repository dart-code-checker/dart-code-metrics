import 'package:analyzer/dart/ast/ast.dart';

class CorrectIdentifierLengthValidator {
  final int maxLength;
  final int minLength;
  final Iterable<String> exception;

  CorrectIdentifierLengthValidator(
    this.maxLength,
    this.minLength,
    this.exception,
  );

  bool isValid<T>(T element) {
    if (element is VariableDeclaration) {
      return _validate(element.name.name);
    }

    return true;
  }

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
