class WithoutErrorExample {
  final abc;
  const bcd;

  WithoutErrorExample.todo() {
    final abc = 1;
    const bcd = 1;
  }

  WithoutErrorExample._() {
    final abc = 1;
    const bcd = 1;
  }

  bool get abcd => false;

  bool set bcde() => true;

  void test() {
    final bcd = 1;
    const abc = 1;
  }
}

void test() {
  final abc = 0;
  final bcd = 1;
}

final abc = 1;
const bcd = 1;

enum Enum {
  abc,
  bcd,
}

extension Extension on String {
  onExtension() {
    final abc = 1;
    const bcd = 1;
  }
}

mixin Mixin {
  final abc = 1;
  const bcd = 1;
}
