class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
        ),
      );
}

class MyWidget2 extends StatelessWidget {
  const MyWidget2({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('label'),
          onPressed: () {},
        ),
      );
}

class MyWidget3 extends StatelessWidget {
  const MyWidget3({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {},
        ),
      );
}

class MyWidget4 extends StatelessWidget {
  const MyWidget4({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton.small(
          onPressed: () {},
        ),
      );
}

class MyWidget6 extends StatelessWidget {
  const MyWidget6({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'heroTag',
          onPressed: () {},
        ),
      );
}

class MyWidget7 extends StatelessWidget {
  const MyWidget7({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'heroTag',
          label: const Text('label'),
          onPressed: () {},
        ),
      );
}

class MyWidget8 extends StatelessWidget {
  const MyWidget8({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton.large(
          heroTag: 'heroTag',
          onPressed: () {},
        ),
      );
}

class MyWidget9 extends StatelessWidget {
  const MyWidget9({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton.small(
          heroTag: 'heroTag',
          onPressed: () {},
        ),
      );
}

class SliverNavBarExample extends StatelessWidget {
  const SliverNavBarExample({super.key});

  @override
  Widget build(BuildContext context) => const CupertinoPageScaffold(
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text('Contacts'),
            ),
          ],
        ),
      );
}

class SliverNavBarExample2 extends StatelessWidget {
  const SliverNavBarExample2({super.key});

  @override
  Widget build(BuildContext context) => const CupertinoPageScaffold(
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text('Contacts'),
              heroTag: 'heroTag',
            ),
          ],
        ),
      );
}

class NavBarExample extends StatelessWidget {
  const NavBarExample({super.key});

  @override
  Widget build(BuildContext context) => const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('CupertinoNavigationBar Sample'),
        ),
        child: Text('data'),
      );
}

class NavBarExample2 extends StatelessWidget {
  const NavBarExample2({super.key});

  @override
  Widget build(BuildContext context) => const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: 'heroTag',
          middle: Text('CupertinoNavigationBar Sample'),
        ),
        child: Text('data'),
      );
}

class BuildContext {}

class Key {}

class Widget {
  final Key? key;

  const Widget(this.key);
}

class StatelessWidget extends Widget {
  const StatelessWidget(super.key);
}

class Scaffold extends Widget {
  final Widget? floatingActionButton;

  Scaffold({
    this.floatingActionButton,
  });
}

class CupertinoPageScaffold extends Widget {
  final Widget child;
  final Widget? navigationBar;

  const CupertinoPageScaffold({
    super.key,
    required this.child,
    this.navigationBar,
  });
}

class CustomScrollView extends Widget {
  final List<Widget> slivers;

  const CustomScrollView({
    super.key,
    required this.slivers,
  });
}

class Text extends Widget {
  final String data;

  const Text(
    this.data, {
    super.key,
  });
}
