const List<String> items = <String>['a', 'b', 'c'];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              childCount: items.length,
              (BuildContext context, int index) => itemBuilder(items[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemBuilder(String v) {
    return Text(v);
  }
}

class StatelessWidget extends Widget {
  Widget build(BuildContext context) {}
}

class Widget {}

class BuildContext {}

class Scaffold extends Widget {
  final Widget body;

  const Scaffold(this.body);
}

class CustomScrollView extends Widget {
  final Iterable<Widget> slivers;

  const CustomScrollView({required this.slivers});
}

class SliverGrid extends Widget {
  final Widget delegate;

  const SliverGrid({required this.delegate});
}

class SliverChildBuilderDelegate extends Widget {
  final int childCount;
  final WidgetBuilder builder;

  const SliverChildBuilderDelegate(this.builder, {required this.childCount});
}

typedef WidgetBuilder = Widget Function(BuildContext context);
