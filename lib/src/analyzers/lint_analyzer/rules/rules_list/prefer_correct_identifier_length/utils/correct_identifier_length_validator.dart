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

  String? getMessage<T>(T element) {
    if (element is VariableDeclaration) {
      return _validate('variable', element.name.name);
    }

    return null;
  }

  String? _validate(String type, String name) {
    if (!exception.contains(name) && name.length < minLength) {
      return 'Too short $type name length.';
    } else if (name.length > maxLength) {
      return 'Too long $type name length.';
    } else {
      return null;
    }
  }
}
