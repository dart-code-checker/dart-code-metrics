// LINT Check regular class without uppercase
class example {
  example();
}

// LINT Private class without uppercase
class _example {
  _example();
}

// LINT Private class with short name
class _ex {
  _ex();
}

// LINT Class with short name
class ex {
  ex();
}

// LINT Private class with long name
class _ExampleWithLongName {
  _ExampleWithLongName();
}

// LINT Class with long name
class ExampleWithLongName {
  ExampleWithLongName();
}

// Check private class with name contained in exclude config
class _exampleExclude {
  _exampleExclude();
}

// Check regular class without error
class Example {}

// Check private class without error
class _Example {}
