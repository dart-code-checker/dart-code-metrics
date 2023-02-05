// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

import '../../utils/dart_types_utils.dart';
import '../../utils/node_utils.dart';
import '../../utils/suppression.dart';

typedef DeclarationUsages = Map<Element, Iterable<FormalParameter>>;

class DeclarationsVisitor extends RecursiveAstVisitor<void> {
  final DeclarationUsages declarations = {};

  final Suppression _suppression;
  final String _pattern;

  DeclarationsVisitor(this._suppression, this._pattern);

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    super.visitMethodDeclaration(node);

    final lineIndex = _suppression.lineInfo.getLocation(node.offset).lineNumber;
    if (_suppression.isSuppressedAt(_pattern, lineIndex)) {
      return;
    }

    final parameters = node.parameters?.parameters;
    if (parameters == null || !_hasNullableParameters(parameters)) {
      return;
    }

    _getDeclarationElement(node, parameters);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    super.visitFunctionDeclaration(node);

    final lineIndex = _suppression.lineInfo.getLocation(node.offset).lineNumber;
    if (_suppression.isSuppressedAt(_pattern, lineIndex)) {
      return;
    }

    final parameters = node.functionExpression.parameters?.parameters;
    if (isEntrypoint(node.name.lexeme, node.metadata) ||
        (parameters == null || !_hasNullableParameters(parameters))) {
      return;
    }

    _getDeclarationElement(node, parameters);
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    super.visitConstructorDeclaration(node);

    final lineIndex = _suppression.lineInfo.getLocation(node.offset).lineNumber;
    if (_suppression.isSuppressedAt(_pattern, lineIndex)) {
      return;
    }

    final parameters = node.parameters.parameters;
    if (!_hasNullableParameters(parameters)) {
      return;
    }

    _getDeclarationElement(node, parameters);
  }

  bool _hasNullableParameters(Iterable<FormalParameter> parameters) =>
      parameters.any((parameter) {
        final type = parameter.declaredElement?.type;

        return type != null &&
                (isNullableType(type) &&
                    (!parameter.isOptional ||
                        parameter.isOptional && parameter.isRequired)) ||
            (parameter is DefaultFormalParameter &&
                parameter.defaultValue == null);
      });

  void _getDeclarationElement(
    Declaration node,
    Iterable<FormalParameter> parameters,
  ) {
    final element = node.declaredElement;

    if (element != null) {
      declarations[element] = parameters;
    }
  }
}
