import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

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
      synchronousWork4: work4,
    );
  }

  void aSyncFunction({
    required VoidCallback synchronousWork,
    required VoidCallback synchronousWork2,
    required VoidCallback synchronousWork3,
    required VoidCallback synchronousWork4,
  }) {
    synchronousWork();
    synchronousWork2();
    synchronousWork3();
    synchronousWork4();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Future.delayed(const Duration(seconds: 1));
          _incrementCounter();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
