# Ban name

## Rule id {#rule-id}

ban-name

## Severity {#severity}

Style

## Description {#description}

Configure some names that you want to ban.

Example: When you add some extra functionalities to built-in Flutter functions (such as logging for `showDialog`), you may want to ban the original Flutter function and use your own version.

### Example {#example}

Bad:

```dart
// suppose the user configures `showDialog` to be banned
showDialog(); // LINT
```

Good:

```dart
myShowDialog();
```

### Config example {#config-example}

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - ban-name:
        entries:
        - ident: showDialog
          description: Please use myShowDialog in this package
```
