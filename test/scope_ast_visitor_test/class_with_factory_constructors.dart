class SampleClass {
  const SampleClass._();

  factory SampleClass._create() {
    return const SampleClass._();
  }

  factory SampleClass.createInstance() {
    return SampleClass._create();
  }
}
