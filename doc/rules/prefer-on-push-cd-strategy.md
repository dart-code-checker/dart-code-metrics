# Prefer using onPush change detection strategy

> **DEPRECATED!** Information on this page is out of date. You can find the up to date version on our [official site](https://dartcodemetrics.dev/docs/rules/angular/prefer-on-push-cd-strategy).

## Rule id

prefer-on-push-cd-strategy

## Description

Prefer setting `changeDetection: ChangeDetectionStrategy.OnPush` in Angular `@Component` annotations.
OnPush strategy should be used as the default because using Default strategy leads to performance issues.

### Example

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
