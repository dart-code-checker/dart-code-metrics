import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

@immutable
class ScopedDeclaration {
  final Declaration declaration;
  final SimpleIdentifier declarationIdentifier;

  const ScopedDeclaration(this.declaration, this.declarationIdentifier);
}
