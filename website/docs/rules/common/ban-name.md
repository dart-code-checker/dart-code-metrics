# Ban name

## Rule id {#rule-id}

ban-name

## Severity {#severity}

Style

## Description {#description}

Configure some names that you want to ban.

For example, in my own app, I want to ban `showDialog` and force to use `myShowDialog` instead. This is because (let me explain the simplified case) I added logging in `myShowDialog`, and I do want every dialog to be logged.

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
