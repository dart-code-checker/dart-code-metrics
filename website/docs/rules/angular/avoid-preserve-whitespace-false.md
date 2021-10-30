# Avoid preserveWhitespace: false

## Rule id {#rule-id}

avoid-preserve-whitespace-false

## Severity {#severity}

Warning

## Description {#description}

Avoid setting `preserveWhitespace` in Angular `@Component` annotations to false explicitly. Its default value is already false.

### Example {#example}

Bad:

```dart
@Component(
  selector: 'component-selector',
  templateUrl: 'component.html',
  styleUrls: ['component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  preserveWhitespace: false, // LINT
  directives: <Object>[
    coreDirectives,
  ],
)
class Component {
}
```

Good:

```dart
@Component(
  selector: 'component-selector',
  templateUrl: 'component.html',
  styleUrls: ['component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: <Object>[
    coreDirectives,
  ],
)
class Component {
}
```
