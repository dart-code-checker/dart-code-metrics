void main() {
  const str = '';

  final assignment = str.isEmpty ? otherFunction() : bar();
  final boolean = str.isEmpty ? bar() : baz();

  final another = str.isEmpty ? true : false; // LINT
}

bool foo() {
  const str = '';

  return str.isEmpty ? false : true; // LINT
}

bool bar() => foo ? false : true; // LINT

bool baz() => foo ? true : false; // LINT

String otherFunction() => 'str';
