# Prefer entry point imports

## Rule id

prefer-entry-point-imports

## Description

Check that libraries in lib are imported from entry point imports in the same package.

For angular applications importing library from `src` outside `lib` leads to explicit files generation which slows down build.

### Example

In a file outside lib:

Bad:

```dart
import 'package:package_name/src/implementation/export.dart
```

Good:

```dart
import 'package:package_name/export.dart
```
