// LINT Check regular class without uppercase
extension example on String {}

// LINT Private extension without uppercase
extension _example on String {}

// LINT Private extension with short name
extension _ex on String {}

// LINT Extension with short name
extension ex on String {}

// LINT Private extension with long name
extension _ExampleWithLongName on String {}

// LINT extension with long name
extension ExampleWithLongName on String {}

// Check private extension with name contained in exclude config
extension _exampleExclude on String {}

// Check regular extension without error
extension Example on String {}

// Check private enum without error
extension _Example on String {}
