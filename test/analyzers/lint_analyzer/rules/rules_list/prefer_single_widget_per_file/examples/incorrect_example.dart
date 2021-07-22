import 'flutter_defines.dart';

class someWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    ...
  }
}

// LINT
class someOtherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    ...
  }
}

// LINT
class _someOtherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    ...
  }
}

// LINT
class someStatefulWidget extends StatefulWidget {
  @override
  _someStatefulWidgetState createState() => _someStatefulWidgetState();
}

class _someStatefulWidgetState extends State<InspirationCard> {
  @override
  Widget build(BuildContext context) {
//    ...
  }
}
