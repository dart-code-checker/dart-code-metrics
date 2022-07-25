class CoolWidget {
  Widget build() {
    return ListView(child: Widget());
  }
}

class WidgetWithColumn {
  Widget build() {
    // LINT
    return Column(children: [ListView(shrinkWrap: true, children: [])]);
  }
}

class WidgetWithRow {
  Widget build() {
    // LINT
    return Row(children: [ListView(shrinkWrap: true, children: [])]);
  }
}

class WidgetWithList {
  Widget build() {
    // LINT
    return ListView(children: [ListView(shrinkWrap: true, children: [])]);
  }
}

class ListView extends Widget {
  final bool shrinkWrap;
  final List<Widget> children;

  const ListView({required this.shrinkWrap, required this.children});
}

class Column extends Widget {
  final List<Widget> children;

  const Column({required this.children});
}

class Row extends Widget {
  final List<Widget> children;

  const Row({required this.children});
}

class Widget {}
