// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

class PublicCodeVisitor extends GeneralizingAstVisitor<void> {
  final Set<Element> topLevelElements = {};

  PublicCodeVisitor();

  @override
  void visitCompilationUnitMember(CompilationUnitMember node) {
    if (node is FunctionDeclaration) {
      if (node.name.name == 'main' || _hasPragmaAnnotation(node.metadata)) {
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

  /// See https://github.com/dart-lang/sdk/blob/master/runtime/docs/compiler/aot/entry_point_pragma.md
  bool _hasPragmaAnnotation(Iterable<Annotation> metadata) =>
      metadata.where((annotation) {
        final arguments = annotation.arguments;

        return annotation.name.name == 'pragma' &&
            arguments != null &&
            arguments.arguments
                .where((argument) =>
                    argument is SimpleStringLiteral &&
                    argument.stringValue == 'vm:entry-point')
                .isNotEmpty;
      }).isNotEmpty;
}
