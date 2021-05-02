int bad_f1(int x) => x + 42; // LINT
bool bad_f2(int x) => x != 12; // LINT
void bad_f4(int x) => a * 3.14; // LINT
void bad_f5() => bad_f4(12); // LINT
