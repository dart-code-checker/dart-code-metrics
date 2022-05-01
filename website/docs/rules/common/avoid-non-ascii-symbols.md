# Avoid non ascii symbols

## Rule id {#rule-id}

avoid-non-ascii-symbols

## Severity {#severity}

Warning

## Description {#description}

Warns when a string literal contains non ascii characters. This might indicate that the string was not localized.

### Example {#example}

Bad:

```dart
final chinese = 'hello 汉字'; // LINT
final russian = 'hello привет'; // LINT
final withSomeNonAsciiSymbols = '#!$_&-  éè  ;∞¥₤€'; // LINT
final misspelling = 'inform@tiv€'; // LINT
```

Good:

```dart
final english = 'hello';
final someGenericSymbols ='!@#$%^';
```
