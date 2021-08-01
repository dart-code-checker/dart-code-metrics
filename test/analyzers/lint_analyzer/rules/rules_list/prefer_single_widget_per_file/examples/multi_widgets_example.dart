import 'flutter_defines.dart';

class ExampleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    ...
  }
}

class _PrivateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    ...
  }
}

class _AnotherPrivateWidget extends StatefulWidget {
  @override
  _SomeStatefulWidgetState createState() => _SomeStatefulWidgetState();
}

class _SomeStatefulWidgetState extends State<InspirationCard> {
  @override
  Widget build(BuildContext context) {
//    ...
  }
}
