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

    myMethod(); // LINT
    classWithMethod.myMethod();
    myAsyncMethod();
  }

  @override
  void didUpdateWidget(MyWidget oldWidget) {
    // LINT
    setState(() {
      myString = "Hello";
    });
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

    final widget = ElevatedButton(
      onPressed: () => myMethod(),
      onLongPress: () {
        setState(() {
          myString = data;
        });
      },
      child: Text('PRESS'),
    );

    myMethod(); // LINT
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
