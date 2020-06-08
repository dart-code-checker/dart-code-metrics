# Avoid preserveWhitespace: false

## Rule id
avoid_preserve_whitespace_false

## Description
Avoid setting `preserveWhitespace` in Angular `@Component` annotations to false explicitly. Its default value is already false.

### Example
Bad:
```dart
@Component(
  selector: 'component-selector',
  templateUrl: 'component.html',
  styleUrls: ['component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  preserveWhitespace: false,
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
