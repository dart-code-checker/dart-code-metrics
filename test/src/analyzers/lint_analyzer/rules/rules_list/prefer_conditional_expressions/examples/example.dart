int a = 1;

int testFunction() {
  if (a == 1) {
    a = 2;
  } else if (a == 2) {
    a = 3;
  }

  // LINT
  if (a == 3) {
    a = 2;
  } else {
    a = 3;
  }

  if (a == 4) {
    a = 2;
  } else {
    return 3;
  }

  if (a == 5) {
    return a;
  } else {
    a = 3;
  }

  // LINT
  if (a == 6) {
    return a;
  } else {
    return 3;
  }

  if (a == 7) {
    return 2;
  }

  if (a == 8) {
    a = 3;
  }

  // LINT
  if (a == 9) {
    return a;
  } else
    return 3;

  // LINT
  if (a == 10)
    return a;
  else {
    return 3;
  }

  // LINT
  if (a == 11) {
    a = 2;
  } else
    a = 3;

  // LINT
  if (a == 12)
    a = 2;
  else {
    a = 3;
  }

  if (a == 13)
    a = 2;
  else {
    return 3;
  }

  if (a == 14)
    return a;
  else {
    a = 3;
  }

  if (a == 15) {
    a = 2;
  } else
    return a;

  if (a == 16) {
    return 2;
  } else
    a = 3;

  // LINT
  if (a == 17)
    a = 2;
  else
    a = 3;

  if (a == 18)
    return a;
  else
    a = 3;

  if (a == 19)
    a = 2;
  else
    return a;

  // LINT
  if (a == 20)
    return 2;
  else
    return a;

  if (a == 21) return a;

  if (a == 22) a = 3;
}

int anotherTestFunction() {
  if (a == 2) {
    final b = a;

    return a;
  } else {
    return a;
  }

  if (a == 3) {
    final b = a;

    return 2;
  } else
    return 6;

  if (a == 4) {
    a = 4;
  } else if (a == 5) {
    a = 5;
  } else {
    a = 6;
  }
}

int newCase() {
  final cond = false;
  final delta = 1;
  final value = 9;

  // LINT
  if (cond) {
    value += delta;
  } else {
    value -= delta;
  }

  // LINT
  if (cond) {
    value -= delta;
  } else {
    value += delta;
  }

  // LINT
  if (cond) {
    value -= 2;
  } else {
    value += 5;
  }

  // LINT
  if (cond) {
    value *= 2;
  } else {
    value /= 5;
  }

  // LINT
  bool val = false;
  if (true) {
    val = true;
  } else {
    val = false;
  }
}
