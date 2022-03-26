void main() {
  int good_f1(int x) => x + 1;
  bool good_f2(int x) => x != 0;
  bool good_f3(String x) => x.indexOf(str) != -1;
  final someDay = DateTime(2006, 12, 1);
  final anotherDay = DateTime.utc(2006, 12, 1);
  final f = Intl.message(example: const <String, int>{'Assigned': 3});
  final f = foo(const [32, 12]);
  final f = Future.delayed(const Duration(seconds: 5));
  final f = foo(const Bar(5));
  final number = 500;
  var number = 500;
  var numbers = [100, 200, 300];
  numbers[0];

  Map<int, String> m = {
    1: '',
    2: '',
    3: '',
  };
  String? mv = m[2];
  final mf = m[2];
  print(m[2]);
}
