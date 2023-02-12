class Widget {}

class StatefulWidget extends Widget {}

class FloatingActionButton extends Widget {
  final VoidCallback onPressed;

  const FloatingActionButton({required this.onPressed});
}

class Scaffold extends Widget {
  final Widget floatingActionButton;

  const Scaffold({required this.floatingActionButton});
}

typedef VoidCallback = void Function();

abstract class State<T> {
  void initState();

  void setState(VoidCallback callback) => callback();
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    final work1 = () async {
      print('hello');
    };

    Future<void> work4() async {
      print('work4');
    }

    aSyncFunction(
      synchronousWork: work1, // LINT
      synchronousWork2: () {
        print('work 2');
      },
      // LINT
      synchronousWork3: () async {
        print('work 3');
      },
      synchronousWork4: work4, // LINT
      synchronousWork5: work1,
    );
  }

  void aSyncFunction({
    required VoidCallback synchronousWork,
    required VoidCallback synchronousWork2,
    required VoidCallback synchronousWork3,
    required VoidCallback synchronousWork4,
    required dynamic Function() synchronousWork5,
  }) {
    synchronousWork();
    synchronousWork2();
    synchronousWork3();
    synchronousWork4();
    synchronousWork5();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        // LINT
        onPressed: () async {
          await Future.delayed(const Duration(seconds: 1));
          _incrementCounter();
        },
      ),
    );
  }

  Future<String> doSomeGetRequest() => Future.value('');

  Future<String> doAnotherGetRequest(String input) => Future.value('');

  Future<String> main() => doSomeGetRequest().then(doAnotherGetRequest);
}
