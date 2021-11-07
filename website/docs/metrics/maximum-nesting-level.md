# Maximum Nesting

**Maximum Nesting Level** this is the maximum level of nesting blocks / control structures that are present in a method (or _function_). Code with deep nesting level are often complex and tough to maintain.

Generally the blocks with `if`, `else`, `else if`, `do`, `while`, `for`, `switch`, `catch`, etc statements are the part of nested loops.

## Config example {#config-example}

```yaml
dart_code_metrics:
  ...
  metrics:
    ...
    maximum-nesting-level: 5
    ...
```

## Example {#example}

```dart
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
```

**Maximum Nesting Level** for the example function is **3**.
