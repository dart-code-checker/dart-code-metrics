# Format comments

![Configurable](https://img.shields.io/badge/-configurable-informational)

## Rule id {#rule-id}

format-comment

## Severity {#severity}

Style

## Description {#description}

Prefer format comments like sentences.

Use `ignored-patterns` configuration, if you want to ignore comments that match the given regular expressions.

### Config example {#config-example}

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - format-comment:
        ignored-patterns:
          - ^ cSpell.*  # Ignores all the comments that start with 'cSpell' (for example: '// cSpell:disable-next-line').
```

### Example {#example}

Bad:

```dart
// prefer format comments like sentences // LINT
class Test {
  /// with start space with dot. // LINT
  Test() {
    // with start space with dot. // LINT
  }

  /// With start space without dot // LINT
  function() {
    //Without start space without dot // LINT
  }
}
/* prefer format comments 
like sentences */ // LINT
```

Good:

```dart
// Prefer format comments like sentences.
class Test {
  /// With start space with dot.
  Test() {
    // With start space with dot.
  }

  /// With start space without dot.
  function() {
    // Without start space without dot.
  }
}
/* Prefer format comments 
like sentences. */ 
```
