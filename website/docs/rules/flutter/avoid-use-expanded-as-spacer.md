# Avoid use Expanded widget instead of Spacer

## Rule id {#rule-id}

avoid-use-expanded-as-spacer

## Severity {#severity}

Style

## Description {#description}

The rule should detect Expanded widgets that contain empty SizedBox/Container and propose to replace them with Spacer()

### Example {#example}

Bad:

```dart
Column(
    children: [
        Container(),
        const Expanded(child: SizedBox()),
        Container(),
    ]
)
```

Good:

```dart
Column(
    children: [
        Container(),
        const Spacer(),
        Container(),
    ]
)
```
