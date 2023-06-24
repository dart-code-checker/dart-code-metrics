void func() {
  if (!(x == 1)) {} // LINT

  if (!(x != 1)) {} // LINT

  if (!(x > 1)) {} // LINT

  if (!(x < 1)) {} // LINT

  if (!(x >= 1)) {} // LINT

  if (!(x <= 1)) {} // LINT

  var b = !(x != 1) ? 1 : 2; // LINT

  var foo = !(x <= 4); // LINT

  function(!(x == 1)); // LINT

  if (!(a > 4 && b < 2)) {} // LINT

  var list = [if (!(x == 1)) 5];
}

void func2() {
  if (x != 1) {}

  if (x == 1) {}

  if (x <= 1) {}

  if (x >= 1) {}

  if (x < 1) {}

  if (x > 1) {}

  var b = x == 1 ? 1 : 2;

  var a = !x ? 1 : 2;

  var foo = x > 4;

  function(x != 1);

  if (a <= 4 || b >= 2) {}

  var list = [if (x != 1) 5];
}
