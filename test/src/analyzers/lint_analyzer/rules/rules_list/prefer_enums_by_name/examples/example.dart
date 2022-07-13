import 'dart:async';

void main() async {
  SomeEnums.values.byName('first');
  // LINT
  SomeEnums.values.firstWhere((element) => element.name == 'first');
  // LINT
  SomeEnums.values
      .firstWhere((element) => element.name == 'second', orElse: () => null);
}

enum SomeEnums { first, second }
