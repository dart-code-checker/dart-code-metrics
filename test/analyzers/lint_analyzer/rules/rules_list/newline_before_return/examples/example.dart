// ignore_for_file: always_put_control_body_on_new_line, newline-before-return
int simpleFunction() {
  var a = 4;

  if (a > 70) {
    /* multi line
      comment */
    return a + 1;
  } else if (a > 65) {
    a++;
    /* multi line
      comment */
    return a + 1;
  } else if (a > 60) {
    a++;

    /* multi line
      comment */
    return a + 2;
  } else if (a > 55) {
    a--;
    /* multi line
      comment */

    return a + 3;
  }

  if (a > 50) {
    // simple comment
    // simple comment second line
    return a + 1;
  } else if (a > 45) {
    a++;
    // simple comment
    // simple comment second line

    return a + 2;
  } else if (a > 40) {
    a++;
    // simple comment

    // simple comment second line
    return a + 2;
  } else if (a > 35) {
    a--;

    // simple comment
    // simple comment second line
    return a + 3;
  }

  if (a > 30) {
    // simple comment
    return a + 1;
  } else if (a > 25) {
    a++;
    // simple comment
    return a + 2;
  } else if (a > 20) {
    a--;

    // simple comment
    return a + 3;
  }

  if (a > 15) {
    return a + 1;
  } else if (a > 10) {
    a++;
    return a + 2;
  } else if (a > 5) {
    a--;

    return a + 3;
  }

  if (a > 4) return a + 1;

  if (a > 3) return a + 2;

  if (a > 2) {
    return a + 3;
  }

  return a;
}
