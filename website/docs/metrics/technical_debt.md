# Technical Debt

The cost of additional rework caused by choosing an easy (limited) solution now instead of using a better approach that would take longer. The metric count debt based on pattern:

- todo comment

```dart
void fooBar() {
  // TODO: need migrate on logger
  debugPrint('log');
}
```

- suppressing rules comment

```dart
// ignore_for_file: unused_local_variable

void fooBar() {
  // ignore: invalid_assignment
  int x = '';
}
```

- cast to `dynamic`

```dart
void fooBar() {
  final a = Foo() as dynamic;
}
```

- `Deprecated` annotation comment

```dart
@Deprecated('Use Bar class')
class Foo {}
```

- Non migrated files on nullsafety

```dart
// @dart=2.9

void fooBar() {
  debugPrint('log');
}
```

You can configure cost of every supported case, and  specify unit type of the debt.

## Config example {#config-example}

```yaml
dart_code_metrics:
  ...
  metrics:
    ...
    technical-debt:
      threshold: 1
      todo-cost: 161
      ignore-cost: 320
      ignore-for-file-cost: 396
      as-dynamic-cost: 322
      deprecated-annotations-cost: 37
      file-nullsafety-migration-cost: 41
      unit-type: "USD"
    ...
```

## Example {#example}

```dart
// @dart=2.9

// ignore_for_file: always_declare_return_types

@Deprecated('Use Bar class')
class Foo {}

// TODO(developer): flutter style todo comment
void fooBar() {
  // ignore: always_put_control_body_on_new_line
  final a = Foo() as dynamic;
}

```

**Technical Debt** for the example function is **955 USD**.
