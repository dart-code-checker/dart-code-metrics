// ignore_for_file: unused_field, prefer-conditional-expressions

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

int simpleFunction(double index) {
  if (index < 10) {
    return 10;
  } else if (index < 20) {
    return 20;
  } else if (index < 40) {
    if (index < 30) {
      return 30;
    }

    return 40;
  }

  return 100;
}

class SimpleClass {
  String _value1;
  int _value2;

  SimpleClass(String text) {
    _value1 = text;
    if (_value1.isNotEmpty) {
      _value2 = _value1.length;
    } else {
      _value2 = 0;
    }
  }

  int get lettersCount => _value1.split(' ').fold(0, (prevValue, element) {
        if (element.isNotEmpty) {
          return prevValue + element.length;
        } else {
          return prevValue;
        }
      });
}

final SimpleClass instance = SimpleClass('example text');

class NestingLevelVisitor extends RecursiveAstVisitor<void> {
  final AstNode _functionNode;
  var _deepestNestingNodesChain = <AstNode>[];

  Iterable<AstNode> get deepestNestingNodesChain => _deepestNestingNodesChain;

  NestingLevelVisitor(this._functionNode);

  @override
  void visitBlock(Block node) {
    final nestingNodesChain = <AstNode>[];

    AstNode astNode = node;
    do {
      if (astNode is Block &&
          (astNode?.parent is! BlockFunctionBody ||
              astNode?.parent?.parent is FunctionExpression ||
              astNode?.parent?.parent is ConstructorDeclaration)) {
        nestingNodesChain.add(astNode);
      }

      astNode = astNode.parent;
    } while (astNode.parent != _functionNode);

    if (nestingNodesChain.length > _deepestNestingNodesChain.length) {
      _deepestNestingNodesChain = nestingNodesChain;
    }

    super.visitBlock(node);
  }
}
