# Maximum Nesting

**Maximum Nesting** is the maximum nesting level of blocks / control structures that are present in a method / function. Code with deep nesting level are often complex and tough to maintain.

Generally the blocks with `if`, `else`, `else if`, `do`, `while`, `for`, `switch`, `catch`, etc statements are the part of nested loops.

Example:

```dart
void visitBlock(Block node) {
  final lines = <int>[];

  AstNode astNode = node;
  do {
    if (astNode is Block) {
      if (astNode?.parent is! BlockFunctionBody ||
          astNode?.parent?.parent is FunctionExpression) {
        lines.add(_lineInfo.getLocation(astNode.offset).lineNumber);
      }
    }

    astNode = astNode.parent;
  } while (astNode.parent != _function);

  if (lines.isNotEmpty) {
    _nestingLines.add(lines);
  }

  super.visitBlock(node);
}
```

**Maximum Nesting** for example function is **3**.
