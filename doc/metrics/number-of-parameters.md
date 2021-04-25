# Number of Parameters

The number of parameters is the number of parameters received by a method (or _function_). If a method receive too many parameters, it is difficult to call and also difficult to change if it's called from many places.

Example:

```dart
  MetricComputationResult<int> computeImplementation(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    ResolvedUnitResult source,
  ) {
    int parametersCount;
    if (node is FunctionDeclaration) {
      parametersCount = node.functionExpression?.parameters?.parameters?.length;
    } else if (node is MethodDeclaration) {
      parametersCount = node?.parameters?.parameters?.length;
    }

    return MetricComputationResult(value: parametersCount ?? 0);
  }
```

**Number of Parameters** for the example function is **4**.
