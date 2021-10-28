class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends BaseState<MyWidget> {
  String myString = '';

  @override
  void initState() {
    super.initState();

    classWithMethod.myMethod();
    myAsyncMethod();
  }

  void myMethod() {
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
    final widget = ElevatedButton(
      onPressed: () => myMethod(),
      onLongPress: () {
        setState(() {
          myString = data;
        });
      },
      child: Text('PRESS'),
    );

    myAsyncMethod();

    return ElevatedButton(
      onPressed: () => myMethod(),
      onLongPress: () {
        setState(() {
          myString = data;
        });
      },
      child: Text('PRESS'),
    );
  }
}

class ElevatedButton {
  final Function onPressed;
  final Function onLongPress;
  final dynamic child;

  const ElevatedButton(
    this.onPressed,
    this.onLongPress,
    this.child,
  );
}

class SomeClassWithMethod {
  void myMethod() {}
}

class State<T> {}

class BaseState<T> extends State<T> {}
