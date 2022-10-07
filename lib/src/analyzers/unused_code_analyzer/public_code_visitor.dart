// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

import '../../utils/node_utils.dart';
import '../../utils/suppression.dart';

class PublicCodeVisitor extends GeneralizingAstVisitor<void> {
  final Set<Element> topLevelElements = {};

  final Suppression _suppression;
  final String _pattern;

  PublicCodeVisitor(this._suppression, this._pattern);

  @override
  void visitCompilationUnitMember(CompilationUnitMember node) {
    final lineIndex = _suppression.lineInfo.getLocation(node.offset).lineNumber;
    if (_suppression.isSuppressedAt(_pattern, lineIndex)) {
      return;
    }

    if (node is FunctionDeclaration) {
      if (isEntrypoint(node.name.lexeme, node.metadata)) {
        return;
      }
    }

    _getTopLevelElement(node);
  }

  @override
  void visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    final lineIndex = _suppression.lineInfo.getLocation(node.offset).lineNumber;
    if (_suppression.isSuppressedAt(_pattern, lineIndex)) {
      return;
    }

    final variables = node.variables.variables;

    if (variables.isNotEmpty) {
      _getTopLevelElement(variables.first);
    }
  }

  void _getTopLevelElement(Declaration node) {
    final element = node.declaredElement;

    if (element != null) {
      topLevelElements.add(element);
    }
  }
}
