class PersonWidget extends StatelessWidget {
  PersonWidget({
    required this.name,
    required this.child,
    required this.age,
  });

  final String name;
  final Widget child;
  final int age;

  Widget build(BuildContext context) => Container();
}

final goodPerson = PersonWidget(name: '', child: Container(), age: 42);

final badPerson1 = PersonWidget(name: '', age: 42, child: Container()); // LINT
final badPerson2 = PersonWidget(child: Container(), name: '', age: 42); // LINT
final badPerson3 = PersonWidget(child: Container(), age: 42, name: ''); // LINT
final badPerson4 = PersonWidget(age: 42, child: Container(), name: ''); // LINT
final badPerson5 = PersonWidget(age: 42, name: '', child: Container()); // LINT
