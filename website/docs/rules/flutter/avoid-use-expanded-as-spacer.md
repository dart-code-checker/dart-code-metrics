# Avoid use Expanded widget instead of Spacer

## Rule id {#rule-id}

avoid-use-expanded-as-spacer

## Severity {#severity}

Style

## Description {#description}

The rule detects Expanded widgets that contain empty SizedBox/Container and proposes to replace them with the Spacer widget.

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
