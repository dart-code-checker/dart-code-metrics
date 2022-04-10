# Prefer moving to variable

## Rule id {#rule-id}

prefer-moving-to-variable

## Severity {#severity}

Warning

## Description {#description}

Warns when a property access or a method invocation start with duplicated chains of other invocations / accesses inside a single function or method block.

For instance, you have a function `getUser()` that returns a class instance with two fields: `name` and `age`. If you call this function twice inside another function body, like:

```dart
final name = getUser().name;
final age = getUser().age;
```

the rule will suggest to move `getUser()` call to a single variable.

### Example {#example}

Bad:

```dart
return Container(
  color: Theme.of(context).colorScheme.secondary, // LINT
  child: Text(
    'Text with a background color',
    style: Theme.of(context).textTheme.headline6, // LINT
  ),
);
```

Good:

```dart
final theme = Theme.of(context);

return Container(
  color: theme.colorScheme.secondary,
  child: Text(
    'Text with a background color',
    style: theme.textTheme.headline6,
  ),
);
```
