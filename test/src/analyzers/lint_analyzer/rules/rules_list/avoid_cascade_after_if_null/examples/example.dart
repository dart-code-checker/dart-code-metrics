class Cow {
  void moo() {}
}

class Ranch {
  final Cow? _cow;

  Ranch([Cow? cow])
      : _cow = cow ?? Cow()
          ..moo(); // LINT
}

void main() {
  final Cow? nullableCow;

  final cow = nullableCow ?? Cow()
    ..moo(); // LINT
  final cow = (nullableCow ?? Cow())..moo();
  final cow = nullableCow ?? (Cow()..moo());
}
