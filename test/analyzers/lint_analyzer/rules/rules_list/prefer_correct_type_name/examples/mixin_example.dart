// LINT Check regular mixin without uppercase
mixin example {}

// LINT Private mixin without uppercase
mixin _example {}

// LINT Private mixin with short name
mixin _ex {}

// LINT mixin with short name
mixin ex {}

// LINT Private mixin with long name
mixin _ExampleWithLongName {}

// LINT Mixin with long name
mixin ExampleWithLongName {}

// Check private mixin with name contained in exclude config
mixin _exampleExclude {}

// Check regular mixin without error
mixin Example {}

// Check private mixin without error
mixin _Example {}
