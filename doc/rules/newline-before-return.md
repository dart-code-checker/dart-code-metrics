# New line before return

## Rule id

newline-before-return

## Description

Enforces blank line between statements and return in a block.

### Example

Bad:

```dart
  if ( ... ) {
    ...
    return ...; // LINT
  }
```

Good:

```dart
  if ( ... ) {
    return ...;
  }

  if ( ... ) {
    ...

    return ...;
  }
```
