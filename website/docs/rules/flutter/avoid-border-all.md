# Avoid using Border.all constructor

![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

## Rule id {#rule-id}

avoid-border-all

## Severity {#severity}

Performance

## Description {#description}

`Border.all` constructor calls const `Border.fromBorderSide` constructor under the hood. This rule allows to
replace
`Border.all` with const `Border.fromBorderSide`.

### Example {#example}

Bad:

```dart

class BorderWidget extends StatelessWidget {
  final Widget child;

  const RoundedWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      border: Border.all({
        Color color = const Color(0xFF000000),
        double width = 1.0,
        BorderStyle style = BorderStyle.solid,
      }), //LINT
      child: child,
    );
  }
}
```

Good:

```dart

class BorderWidget extends StatelessWidget {
  final Widget child;

  const RoundedWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      border: const Border.fromBorderSide(BorderSide(
        color: const Color(0xFF000000),
        width: 1.0,
        style: BorderStyle.solid,
      )), 
      child: child,
    );
  }
}
```