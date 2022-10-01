import 'flutter_defines.dart';

class MyWidget extends StatelessWidget {
  Widget build(BuildContext _) => Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(1, 1, 0, 0), // LINT
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12), // LINT
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(1, 1, 1, 1), // LINT
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(3, 2, 3, 2), // LINT
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(3, 0, 0, 2), // LINT
        ),
        Container(
          padding: EdgeInsets.fromLTRB(3, _test, 2 - 2, test()), // LINT
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(1.0, 1.0, 0.0, 0.0), // LINT
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0), // LINT
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0), // LINT
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(3.0, 2.0, 3.0, 2.0), // LINT
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(3.0, 0.0, 0.0, 2.0), // LINT
        ),
        Container(
          padding: EdgeInsets.fromLTRB(3.0, _test, 2 - 2, test()), // LINT
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0), // LINT
        ),
        Container(
          padding: EdgeInsets.fromLTRB(3, 4, 5, 6),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(3, 4, 4, 6),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(6, 4, 5, 6),
        ),
      ]);
}

const _test = 0.0;

double test() => 0;
