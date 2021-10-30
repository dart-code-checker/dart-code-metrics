# New line before return

## Rule id {#rule-id}

newline-before-return

## Severity {#severity}

Style

## Description {#description}

Enforces blank line between statements and return in a block.

### Example {#example}

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
