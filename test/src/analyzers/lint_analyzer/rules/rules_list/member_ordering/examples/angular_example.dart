class Test {
  Test();

  @ViewChild('')
  Element view; // LINT

  @ViewChild('')
  Iterable<Element> views; // LINT

  @ContentChild('')
  Element content; // LINT

  @ContentChildren('')
  Iterable<Element> contents; // LINT

  @Input()
  String input; // LINT

  @Output()
  Stream<void> get click => null; // LINT

  @HostBinding('')
  bool value = false;

  @HostListener('')
  void handle() => null; // LINT
}
