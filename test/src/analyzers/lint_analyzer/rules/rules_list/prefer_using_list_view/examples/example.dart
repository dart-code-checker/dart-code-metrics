void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // LINT
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Wow lint rule'),
          Text('Wow another lint rule'),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Wow lint rule'),
          Text('Wow another lint rule'),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Wow lint rule'),
          Text('Wow another lint rule'),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Text(),
        ),
      ),
    );
  }
}

class SingleChildScrollView {
  final Widget child;

  const SingleChildScrollView({required this.child});
}

class Column extends Widget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;

  const Column({required this.children, required this.mainAxisAlignment});
}

enum MainAxisAlignment { start }

class StatelessWidget extends Widget {}

class Widget {
  const Widget();
}

class Text extends Widget {
  final String? text;

  const Text(this.text);
}

class MaterialApp extends Widget {
  final Widget home;

  const MaterialApp({required this.home});
}

class Scaffold extends Widget {
  final Widget body;

  const Scaffold({required this.body});
}

class BuildContext {}
