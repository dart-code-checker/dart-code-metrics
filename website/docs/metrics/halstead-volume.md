# Halstead Volume

The Halstead metrics are based on the numbers of operators and operands.

First we need to decide what we mean by operators and operands. Operators and operands are defined by their relationship to each other – in general an operator carries out an action and an operand participates in such action. A simple example of an operator is something that carries out an operation using zero or more operands. An operand is something that may participate in an interaction with zero or more operators. So let’s look at the example:

```dart
int x = x + 1;
```

`x` occurs twice so if we take `int`, `x` and `1` as operands and `=`, `+` as operators we have 4 operands (3 unique) and 2 operators (2 unique). Taking **OP** as the number of operators, **OD** as the number of operands, **UOP** as the number of unique operators and **UOD** as the number of unique operands we define the primitive Halstead metrics as:

* The Halstead Length (LTH) is: `OP + OD`
* The Halstead Vocabulary (VOC) is: `UOP + UOD`

The Halstead Volume is based on the Length and the Vocabulary.

* Halstead Volume (VOL) is: `LTH * log2(VOC)`

You can view this as the bulk of the code – how much information does the reader of the code have to absorb to understand its meaning. The biggest influence on the `Volume` metric is the `Halstead Length` which causes a linear increase in the Volume i.e doubling the Length will double the Volume. In case of the Vocabulary the increase is logarithmic. For example with a Length of 10 and a Vocabulary of 16 the Volume is 40. If we double the Length the Volume doubles to 80. If we keep the Length at 10 and double the Vocabulary to 32 we get a volume of 50.

## Config example {#config-example}

```yaml
dart_code_metrics:
  ...
  metrics:
    ...
    halstead-volume: 150
    ...
```

## Example {#example}

```dart
MetricComputationResult<double> computeImplementation(
  Declaration node,
  Iterable<ScopedClassDeclaration> classDeclarations,
  Iterable<ScopedFunctionDeclaration> functionDeclarations,
  InternalResolvedUnitResult source,
) {
  final visitor = HalsteadVolumeAstVisitor();
  node.visitChildren(visitor);

  final lth = visitor.operators + visitor.operands;

  final voc = visitor.uniqueOperators + visitor.uniqueOperands;

  final vol = lth * _log2(voc);

  return MetricComputationResult<double>(value: vol);
}
```

**Halstead Volume** for the example function is **138**.
