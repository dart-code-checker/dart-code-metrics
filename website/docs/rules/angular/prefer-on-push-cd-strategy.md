# Prefer using onPush change detection strategy

## Rule id {#rule-id}

prefer-on-push-cd-strategy

## Severity {#severity}

Warning

## Description {#description}

Prefer setting `changeDetection: ChangeDetectionStrategy.OnPush` in Angular `@Component` annotations.
OnPush strategy should be used as the default because using Default strategy leads to performance issues.

### Example {#example}

Bad:

```dart
@Component(
  selector: 'component-selector',
  templateUrl: 'component.html',
  styleUrls: ['component.css'],
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
