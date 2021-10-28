// LINT Check regular enum without uppercase
enum example {
  param1,
  param2,
}

// LINT Private enum without uppercase
enum _example {
  param1,
  param2,
}

// LINT Private enum with short name
enum _ex {
  param1,
  param2,
}

// LINT Enum with short name
enum ex {
  param1,
  param2,
}

// LINT Private enum with long name
enum _ExampleWithLongName {
  param1,
  param2,
}

// LINT Enum with long name
enum ExampleWithLongName {
  param1,
  param2,
}

// Check private enum with name contained in exclude config
enum _exampleExclude {
  param1,
  param2,
}

// Check regular enum without error
enum Example {
  param1,
  param2,
}

// Check private enum without error
enum _Example {
  param1,
  param2,
}
