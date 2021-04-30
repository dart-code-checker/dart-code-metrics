// ignore_for_file: double-literal-format, unused_local_variable
void main() {
  const a = [
    05.23, // LINT
    5.23,
    003.6e+5, // LINT
    3.6e+5,
    -012.2, // LINT
    -12.2,
    -001.1e-1, // LINT
    -1.1e-1,
  ];

  const b = [
    .257, // LINT
    0.257,
    .16e+5, // LINT
    0.16e+5,
    -.259, // LINT
    -0.259,
    -.14e-5, // LINT
    -0.14e-5,
  ];

  const c = [
    0.2100, // LINT
    0.21,
    0.100e+5, // LINT
    0.1e+5,
    -0.2500, // LINT
    -0.25,
    -0.400e-5, // LINT
    -0.4e-5,
  ];

  const d = [
    0.0,
    -0.0,
    12.0e+1,
    150,
    0x015,
    0x020,
  ];
}
