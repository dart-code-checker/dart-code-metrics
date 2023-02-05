class Box {
  /// The value this wraps
  Object? _value;

  /// true if this box contains a value.
  bool get hasValue => _value != null;
}

//not if there is nothing before it
test() => false;

void greet(String name) {
  // assume we have a valid name.
  print('Hi, $name!');
}

/// deletes the file at [path] from the file system.
void delete(String path) {}

/// {@template template_name}
void f1() {}

/// {@endtemplate}
void f2() {}

/// {@macro template_name}
void f3() {}

/// {@template my_project.my_class.my_method}
void f4() {}

/// {@nodoc}
void f5() {}
