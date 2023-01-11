import 'example.dart' as prefix;
import 'generics_example.dart';

void main() {
  AnotherEnum.anotherValue;
  AnotherEnum.anotherValue;
  AnotherEnum.firstValue;

  prefix.SomeValue.firstValue;
  prefix.SomeValue.firstValue;
  prefix.SomeValue.secondValue;

  prefix.SomeClass.value;
  prefix.SomeClass.value;
  prefix.instance.field;

  print(prefix.SomeValue.entry1);
  print(prefix.SomeValue.entry2);
}
