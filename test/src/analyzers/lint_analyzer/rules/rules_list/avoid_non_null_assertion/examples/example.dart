class Test {
  String? field;

  Test? object;

  void method() {
    field!.contains('other'); // LINT

    field?.replaceAll('from', 'replace');

    if (filed != null) {
      field.split(' ');
    }

    object!.field!.contains('other'); // LINT

    object?.field?.contains('other');

    final field = object?.field;
    if (field != null) {
      field.contains('other');
    }

    final map = {'key': 'value'};
    map['key']!.contains('other');

    object!.method(); // LINT

    object?.method();
  }
}
