# New line before return

> **DEPRECATED!** Information on this page is out of date. You can find the up to date version on our [official site](https://dartcodemetrics.dev/docs/rules/common/newline-before-return).

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
