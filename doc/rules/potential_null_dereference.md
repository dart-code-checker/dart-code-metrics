# Potential null dereference

## Rule id

potential-null-dereference

## Description

Check for potential null dereference in conditional expressions and if statements.

### Example

Bad:

```dart
if (obj != null || obj.foo()) { ... } // in obj.foo invocation obj could be null

if (obj == null && obj.foo()) { ... } // in obj.foo invocation obj is always null

if (obj == null) {
  ...
  var bar = obj.foo(); // in obj.foo invocation obj is always null
  ...
}
```

Good:

```dart
if (obj != null && obj.foo()) { ... }

if (obj == null || obj.foo()) { ... }

if (obj != null) {
  ...
  var bar = obj.foo();
  ...
}
```
