# No empty block

## Rule id
no-empty-block

## Description
Disallows empty blocks except catch clause block. Blocks with a todo comment inside are not considered empty.

Empty blocks are often indicators of missing code.

Inspired by TSLint (https://palantir.github.io/tslint/rules/no-empty/)

### Example
Bad:
```dart
  if ( ... ) {

  }

  [1, 2, 3, 4].forEach((val) {});


  void function() {}
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
