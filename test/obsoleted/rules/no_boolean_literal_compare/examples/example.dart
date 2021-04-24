void main() {
  const exampleString = 'text';

  var a = true;

  var b = a == true;

  var c = b != true;

  var d = true == c;

  var e = false != c;

  if (e == true) {}

  if (e != false) {}

  var f = exampleString?.isEmpty == true;

  var g = true == exampleString?.isEmpty;

  var h = exampleString.isEmpty == true;

  var i = true == exampleString.isEmpty;

  [true, false]
      .where((value) => value == false)
      .where((value) => value != false);

  var y = a != e;
  var z = a == e;

  if (b == d) {}

  if (b != d) {}

  [true, false].where((value) => value == true).where((value) => value == c);

  dynamic dyn = 'a';
  var dynamicWithBoolean = dyn == true;
  var booleanWithDynamic = false == dyn;
}
