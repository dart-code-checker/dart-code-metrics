int simpleFunction() {
  try {} catch (_) {} // LINT

  var a = 4;

  // LINT
  if (a > 70) {
  } else if (a > 65) {
    // TODO(developerName): message.
  } else if (a > 60) {
    return a + 2;
  }

  // LINT
  [1, 2, 3, 4].forEach((val) {});

  [1, 2, 3, 4].forEach((val) {
    // TODO(developerName): need to implement.
  });

  return a;
}

// LINT
void emptyFunction() {}

void emptyFunction2() {
  // TODO(developerName): need to implement.
}
