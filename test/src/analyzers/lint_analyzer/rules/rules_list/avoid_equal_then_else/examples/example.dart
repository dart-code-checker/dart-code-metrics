int value1 = 1;
int value2 = 2;

int testFunction() {
  // LINT
  if (value1 == 1) {
    return value1;
  } else {
    return value1;
  }

  if (value1 == 2) {
    return value2;
  } else {
    return value1;
  }

  if (value1 == 3) {
    return value1;
  }

  // LINT
  if (value1 == 4) {
    value1 = 2;
  } else {
    value1 = 2;
  }

  // LINT
  if (value1 == 5)
    value1 = 2;
  else
    value1 = 2;

  if (value1 == 6) {
    value1 = 5;
  } else if (value1 == 7) {
    value1 = 5;
  }

  if (value1 == 8) {
    value1 = 5;
    // LINT
  } else if (value1 == 9) {
    value1 = 5;
  } else {
    value1 = 5;
  }

  if (value1 == 10) {
    value1 = 5;
  }
}

int anotherTestFunction() {
  if (value2 == 1) {
    // LINT
    return value1 == 11 ? value1 : value1;
  }

  return value1 == 12 ? value1 : value2;
}
