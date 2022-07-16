# Avoid top-level members in tests

## Rule id {#rule-id}

avoid-top-level-members-in-tests

## Severity {#severity}

Warning

## Description {#description}

Warns when a public top-level member (expect the entrypoint) is declared inside a test file.

It helps reduce code bloat and find unused declarations in test files.

### Example {#example}

Bad:

```dart
final public = 1; // LINT

void function() {} // LINT

class Class {} // LINT

mixin Mixin {} // LINT

extension Extension on String {} // LINT

enum Enum { first, second } // LINT

typedef Public = String; // LINT
```

Good:

```dart
final _private = 2;

void _function() {}

class _Class {}

mixin _Mixin {}

extension _Extension on String {}

enum _Enum { first, second }

typedef _Private = String;
```
