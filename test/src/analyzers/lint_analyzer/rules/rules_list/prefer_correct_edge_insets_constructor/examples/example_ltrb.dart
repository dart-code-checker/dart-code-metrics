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
          padding: const EdgeInsets.fromLTRB(3, _test, 2 - 2, test()), // LINT
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
          padding: const EdgeInsets.fromLTRB(3.0, _test, 2 - 2, test()), // LINT
        ),
      ]);
}

const _test = 0;

int test() {
  return 0;
}
