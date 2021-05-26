# Avoid unnecessary setState

## Rule id

avoid-unnecessary-setstate

## Description

Warns when `setState` is called inside `initState`, `didUpdateWidget` or `build` methods and when it's called from a `sync` method that is called inside those methods.

Calling setState in those cases will lead to an additional widget rerender which is bad for performance.

Consider changing state directly without calling `setState`.

Additional resources:

* <https://stackoverflow.com/questions/53363774/importance-of-calling-setstate-inside-initstate/53373017#53373017>

### Example

Bad:

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String myString = '';

  @override
  void initState() {
    super.initState();

    // LINT
    setState(() {
      myString = "Hello";
    });

    if (condition) {
      // LINT
      setState(() {
        myString = "Hello";
      });
    }

    myStateUpdateMethod(); // LINT
  }

  @override
  void didUpdateWidget(MyWidget oldWidget) {
    // LINT
    setState(() {
      myString = "Hello";
    });
  }

  void myStateUpdateMethod() {
    setState(() {
      myString = "Hello";
    });
  }

  @override
  Widget build(BuildContext context) {
    // LINT
    setState(() {
      myString = "Hello";
    });

    if (condition) {
      // LINT
      setState(() {
        myString = "Hello";
      });
    }

    myStateUpdateMethod(); // LINT

    return ElevatedButton(
      onPressed: () => myStateUpdateMethod(),
      onLongPress: () {
        setState(() {
          myString = data;
        });
      },
      child: Text('PRESS'),
    );
  }
}
```

Good:

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String myString = '';

  final classWithMethod = SomeClassWithMethod();

  @override
  void initState() {
    super.initState();

    myString = "Hello";

    classWithMethod.myMethod();
    myAsyncMethod();
  }

  @override
  void didUpdateWidget(MyWidget oldWidget) {
    myString = "Hello";
  }

  void myStateUpdateMethod() {
    setState(() {
      myString = "Hello";
    });
  }

  Future<void> myAsyncMethod() async {
    final data = await service.fetchData();

    setState(() {
      myString = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    myAsyncMethod();

    return ElevatedButton(
      onPressed: () => myStateUpdateMethod(),
      onLongPress: () {
        setState(() {
          myString = data;
        });
      },
      child: Text('PRESS'),
    );
  }
}
```
