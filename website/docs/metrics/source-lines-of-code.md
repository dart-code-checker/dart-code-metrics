# Source lines of Code

**Source lines of Code** is an approximate number of source code lines in a function or method. Blank or comment lines are not counted.

This metric is used to measure the size of a computer program by counting the number of lines in the text of the program's source code. **SLOC** is typically used to predict the amount of effort that will be required to develop a program, as well as to estimate programming productivity or maintainability once the software is produced.

## Used for {#used-for}

* [Long Method](../anti-patterns/long-method.md)

## Config example {#config-example}

```yaml
dart_code_metrics:
  ...
  metrics:
    ...
    source-lines-of-code: 50
    ...
```

## Example {#example}

```dart
MetricComputationResult<int> computeImplementation(
  Declaration node,
  Iterable<ScopedClassDeclaration> classDeclarations,
  Iterable<ScopedFunctionDeclaration> functionDeclarations,
  InternalResolvedUnitResult source,
) {
  final visitor = SourceCodeVisitor(source.lineInfo);
  node.visitChildren(visitor);

  return MetricComputationResult(
    value: visitor.linesWithCode.length,
    context: _context(node, visitor.linesWithCode, source),
  );
}
```

**Source lines of Code** for the example function is **6**.
