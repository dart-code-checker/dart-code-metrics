# Lines of Code

The lines of code are the total number of lines in a method (or _function_). The comment lines, and the blank lines are also counted. A longer method is often difficult to maintain, tend to do a lot of things and can make it hard following what's going on.

## Config example {#config-example}

```yaml
dart_code_metrics:
  ...
  metrics:
    ...
    lines-of-code: 100
    ...
```

## Example {#example}

```dart
  MetricComputationResult<int> computeImplementation(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
  ) =>
      MetricComputationResult(
        value: 1 +
            source.lineInfo.getLocation(node.endToken.offset).lineNumber -
            source.lineInfo.getLocation(node.beginToken.offset).lineNumber,
      );
```

**Lines of Code** for the example function is **11**.
