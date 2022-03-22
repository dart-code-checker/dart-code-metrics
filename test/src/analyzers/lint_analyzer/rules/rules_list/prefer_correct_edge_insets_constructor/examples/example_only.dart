import 'flutter_defines.dart';

class MyWidget extends StatelessWidget {
  Widget build(BuildContext _) => Column(children: [
        Container(
          padding: const EdgeInsets.only(
            top: 10,
            left: 5,
            bottom: 10,
            right: 5,
          ), // LINT
        ),
        Container(
          padding:
              const EdgeInsets.only(bottom: 10, right: 10, left: 10, top: 10),
        ),
        Container(
          padding:
              const EdgeInsets.only(bottom: 10, right: 12, left: 12, top: 10),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10, top: 10),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
        ),
      ]);
}
