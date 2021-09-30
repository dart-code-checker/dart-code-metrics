import 'flutter_define.dart';

const _constRadius = BorderRadius.all(Radius.circular(0.0));
final _finalRadius = BorderRadius.circular(1.0); // LINT
const _constValue = 10.0;
final _finalValue = 15.0;

class MyWidget extends StatelessWidget {
  static final staticRadius = BorderRadius.circular(2.0); // LINT

  Widget build(BuildContext _) {
    final buildMethodRadius = BorderRadius.circular(3.0); // LINT
    var buildMethodRadiusVar = BorderRadius.circular(4.0); // LINT

    return Column(children: [
      const ClipRRect(borderRadius: _constRadius),
      ClipRRect(borderRadius: BorderRadius.circular(5.0)), // LINT
      ClipRRect(borderRadius: staticRadius),
      ClipRRect(borderRadius: buildMethodRadius),
      ClipRRect(borderRadius: buildMethodRadiusVar),
      ClipRRect(borderRadius: BorderRadius.circular(_finalValue)),
      ClipRRect(borderRadius: BorderRadius.circular(_constValue)), // LINT
      ClipRRect(
          borderRadius:
              BorderRadius.circular(_constValue - _constValue)), // LINT
      ClipRRect(borderRadius: BorderRadius.circular(_constValue - _finalValue)),
    ]);
  }
}
