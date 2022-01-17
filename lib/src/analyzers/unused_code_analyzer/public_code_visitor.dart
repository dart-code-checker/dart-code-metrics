// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

import '../../utils/node_utils.dart';

class PublicCodeVisitor extends GeneralizingAstVisitor<void> {
  final Set<Element> topLevelElements = {};

  @override
  void visitCompilationUnitMember(CompilationUnitMember node) {
    if (node is FunctionDeclaration) {
      if (isEntrypoint(node.name.name, node.metadata)) {
        return;
      }
    }

    _getTopLevelElement(node);
  }

  @override
  void visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
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
