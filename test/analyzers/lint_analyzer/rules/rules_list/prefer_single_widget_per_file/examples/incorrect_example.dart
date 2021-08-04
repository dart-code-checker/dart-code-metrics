import 'flutter_defines.dart';

class SomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    ...
  }
}

// LINT
class SomeOtherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    ...
  }
}

// LINT
class _SomeOtherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    ...
  }
}

// LINT
class SomeStatefulWidget extends StatefulWidget {
  @override
  _someStatefulWidgetState createState() => _someStatefulWidgetState();
}

class _SomeStatefulWidgetState extends State<InspirationCard> {
  @override
  Widget build(BuildContext context) {
//    ...
  }
}
