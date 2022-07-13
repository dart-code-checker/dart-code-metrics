final public = 1; // LINT
final _private = 2;

void main() {}

void function() {} // LINT

void _function() {}

class Class {} // LINT

class _Class {}

mixin Mixin {} // LINT

mixin _Mixin {}

extension Extension on String {} // LINT

extension _Extension on String {}

enum Enum { first, second } // LINT

enum _Enum { first, second }

typedef Public = String; // LINT

typedef _Private = String;
