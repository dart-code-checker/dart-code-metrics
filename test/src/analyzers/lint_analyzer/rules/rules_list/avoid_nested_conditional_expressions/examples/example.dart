void func() {
  final str = '';

  final oneLevel = str.isEmpty ? 'hello' : 'world';

  final twoLevels = str.isEmpty
      ? str.isEmpty // LINT
          ? 'hello'
          : 'world'
      : 'here';

  final threeLevels = str.isEmpty
      ? str.isEmpty // LINT
          ? str.isEmpty // LINT
              ? 'hi'
              : 'hello'
          : 'here'
      : 'deep';

  final fourLevels = str.isEmpty
      ? str.isEmpty // LINT
          ? str.isEmpty // LINT
              ? str.isEmpty // LINT
                  ? 'hi'
                  : 'hello'
              : 'here'
          : 'deep'
      : 'four';
}
