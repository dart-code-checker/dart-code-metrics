import 'flutter_define.dart';

const _constRadius = BorderRadius.all(16);
final _finalRadius = BorderRadius.circular(8); // LINT
const _constValue = 55;
final _finalValue = 66;

class MyWidget extends StatelessWidget {
  static final staticRadius = BorderRadius.circular(32); // LINT

  Widget build(BuildContext _) {
    final buildMethodRadius = BorderRadius.circular(230); // LINT

    return Column(children: [
      const Container(borderRadius: _constRadius),
      Container(borderRadius: BorderRadius.circular(32)), // LINT
      Container(borderRadius: staticRadius),
      Container(borderRadius: buildMethodRadius),
      Container(borderRadius: BorderRadius.circular(_finalValue)),
      Container(borderRadius: BorderRadius.circular(_constValue)), // LINT
      Container(borderRadius: BorderRadius.circular(_constValue-_finalValue)),
    ]);
  }
}
