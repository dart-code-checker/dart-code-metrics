class PersonWidget extends StatelessWidget {
  PersonWidget({
    required this.child,
    required this.children,
    required this.name,
  });

  final Widget child;
  final List<Widget> children;
  final String name;

  Widget build(BuildContext context) => Container();
}

final goodPerson = PersonWidget(name: '', child: Container(), children: []);

final badPerson1 =
    PersonWidget(name: '', child: Container(), children: []); // LINT
final badPerson2 =
    PersonWidget(child: Container(), children: [], name: ''); // LINT
final badPerson3 =
    PersonWidget(child: Container(), name: '', children: []); // LINT
final badPerson4 =
    PersonWidget(children: [], child: Container(), name: ''); // LINT
final badPerson5 =
    PersonWidget(children: [], name: '', child: Container()); // LINT
