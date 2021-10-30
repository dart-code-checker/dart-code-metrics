# No empty block

## Rule id {#rule-id}

no-empty-block

## Severity {#severity}

Style

## Description {#description}

Disallows empty blocks except catch clause block. Blocks with a todo comment inside are not considered empty.

Empty blocks are often indicators of missing code.

### Example {#example}

Bad:

```dart
  // LINT
  if ( ... ) {

  }

  [1, 2, 3, 4].forEach((val) {}); // LINT


  void function() {} // LINT
```

Good:

```dart
  if ( ... ) {
    // TODO(developername): need to implement.
  }

  [1, 2, 3, 4].forEach((val) {
    // TODO(developername): need to implement.
  });


  void function() {
    // TODO(developername): need to implement.
  }
```

Inspired by [TSLint rule](https://palantir.github.io/tslint/rules/no-empty/)
