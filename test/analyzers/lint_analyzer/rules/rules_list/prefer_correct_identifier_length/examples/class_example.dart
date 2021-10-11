class Example {
  final x = 0; // LINT
  final y = 0; // LINT
  final z = 0;
  final zyt = 0;
  final property = 0;
  final multiplatformConfig = 0; // LINT
  final multiplatformConfigurationPoint = 0; // LINT

  Example.todo() {
    final u = 1; // LINT
    const i = 1; // LINT
  }

  Example._() {
    final u = 1; // LINT
    const i = 1; // LINT
  }

  bool get o => false; // LINT

  bool set p() => true; // LINT

  void test() {
    final u = 1; // LINT
    const i = 1; // LINT
  }
}
