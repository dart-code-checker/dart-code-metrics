import 'flutter_defines.dart';

class MyWidget extends StatelessWidget {
  Widget build(BuildContext _) => Column(children: [
        Container(
          padding: const EdgeInsetsDirectional.only(
            top: 10,
            start: 5,
            bottom: 10,
            end: 5,
          ), // LINT
        ),
        Container(
          padding: const EdgeInsetsDirectional.only(
              bottom: 10, end: 10, start: 10, top: 10), // LINT
        ),
        Container(
          padding: const EdgeInsetsDirectional.only(
              bottom: 10, start: 12, end: 12, top: 10), // LINT
        ),
        Container(
          padding:
              const EdgeInsetsDirectional.only(bottom: 10, top: 10), // LINT
        ),
        Container(
          padding: const EdgeInsetsDirectional.only(start: 10, end: 10), // LINT
        ),
        Container(
          padding: const EdgeInsetsDirectional.only(
            top: 10,
            start: 5,
            bottom: 10,
            end: 5,
          ), // LINT
        ),
        Container(
          padding: const EdgeInsetsDirectional.only(
            bottom: 10.0,
            end: 10.0,
            start: 10.0,
            top: 10.0,
          ), // LINT
        ),
        Container(
          padding: const EdgeInsetsDirectional.only(
            bottom: 10.0,
            start: 12.0,
            end: 12.0,
            top: 10.0,
          ), // LINT
        ),
        Container(
          padding:
              const EdgeInsetsDirectional.only(bottom: 10.0, top: 10.0), // LINT
        ),
        Container(
          padding:
              const EdgeInsetsDirectional.only(start: 10.0, end: 10.0), // LINT
        ),
        Container(
          padding: const EdgeInsetsDirectional.only(start: 10.0, end: 4.0),
        ),
        Container(
          padding: const EdgeInsetsDirectional.only(
            start: 10.0,
            end: 4.0,
            top: 1.0,
            bottom: 11.0,
          ),
        ),
        Container(
          padding: const EdgeInsetsDirectional.only(start: 10.0),
        ),
      ]);
}
