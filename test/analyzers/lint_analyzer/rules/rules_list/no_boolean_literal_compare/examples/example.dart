void main() {
  const exampleString = 'text';

  var a = true;

  var b = a == true; // LINT

  var c = b != true; // LINT

  var d = true == c; // LINT

  var e = false != c; // LINT

  if (e == true) {} // LINT

  if (e != false) {} // LINT

  var f = exampleString?.isEmpty == true;

  var g = true == exampleString?.isEmpty;

  var h = exampleString.isEmpty == true; // LINT

  var i = true == exampleString.isEmpty; // LINT

  [true, false]
      .where((value) => value == false) // LINT
      .where((value) => value != false); // LINT

  var y = a != e;
  var z = a == e;

  if (b == d) {}

  if (b != d) {}

  // LINT
  [true, false].where((value) => value == true).where((value) => value == c);

  dynamic dyn = 'a';
  var dynamicWithBoolean = dyn == true;
  var booleanWithDynamic = false == dyn;
}
