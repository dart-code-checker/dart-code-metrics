@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/member_ordering.dart';
import 'package:test/test.dart';

// ignore_for_file: no_adjacent_strings_in_list

const _content = '''

class Test {
  String _value;

  void doWork  {

  }

  void doAnotherWork {

  }

  final data = 1;

  Test();

  String _doWork() => 'test';

  void _doAnotherWork {

  }

  String get value => _value;

  set value(String str) => _value = str;
}

''';

const _multipleClassesContent = '''

class Test {
  final _data = 1;

  int get data => _data;

  void doWork() {

  }
}

class AnotherTest {
  final _anotherData = 1;

  int get anotherData => _anotherData;

  void anotherDoWork() {

  }
}

''';

const _angularContent = '''

class Test {
  Test();

  @ViewChild('')
  Element view;

  @ViewChild('')
  Iterable<Element> views;

  @ContentChild('')
  Element content;
  
  @ContentChildren('')
  Iterable<Element> contents;

  @Input()
  String input;

  @Output()
  Stream<void> get click => null;

  @HostBinding('')
  bool value = false;

  @HostListener('')
  void handle() => null;
}

''';

const _alphabeticalContent = '''

class Test {
  final value = 1;

  final data = 2;

  final algorithm = 3;

  void work() {

  }

  void create() {

  }

  void init() {

  }

  @Input()
  String last;

  @Input()
  String first;
}

''';

void main() {
  test('MemberOrdering with default config reports about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');
    final parseResult = parseString(
      content: _content,
      // ignore: deprecated_member_use
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    final issues = MemberOrderingRule().check(InternalResolvedUnitResult(
      sourceUrl,
      parseResult.content,
      parseResult.unit,
    ));

    expect(
      issues.every((issue) => issue.ruleId == 'member-ordering'),
      isTrue,
    );
    expect(
      issues.every((issue) => issue.severity == Severity.style),
      isTrue,
    );

    expect(
      issues.map((issue) => issue.location.start.offset),
      equals([86, 177]),
    );
    expect(
      issues.map((issue) => issue.location.start.line),
      equals([13, 23]),
    );
    expect(
      issues.map((issue) => issue.location.start.column),
      equals([3, 3]),
    );
    expect(
      issues.map((issue) => issue.location.end.offset),
      equals([101, 204]),
    );
    expect(
      issues.map((issue) => issue.location.text),
      equals([
        'final data = 1;',
        'String get value => _value;',
      ]),
    );
    expect(
      issues.map((issue) => issue.message),
      equals([
        'public_fields should be before public_methods',
        'public_getters should be before private_methods',
      ]),
    );
  });

  test('MemberOrdering with multiple classes in file reports no issues', () {
    final sourceUrl = Uri.parse('/example.dart');
    final parseResult = parseString(
      content: _multipleClassesContent,
      // ignore: deprecated_member_use
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    final issues = MemberOrderingRule().check(InternalResolvedUnitResult(
      sourceUrl,
      parseResult.content,
      parseResult.unit,
    ));

    expect(
      issues.every((issue) => issue.ruleId == 'member-ordering'),
      isTrue,
    );
    expect(
      issues.every((issue) => issue.severity == Severity.style),
      isTrue,
    );

    expect(issues.isEmpty, isTrue);
  });

  test('MemberOrdering with custom config reports about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');
    final parseResult = parseString(
      content: _content,
      // ignore: deprecated_member_use
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    final config = {
      'order': [
        'constructors',
        'public_setters',
        'private_methods',
        'public_fields',
      ],
    };

    final issues =
        MemberOrderingRule(config: config).check(InternalResolvedUnitResult(
      sourceUrl,
      parseResult.content,
      parseResult.unit,
    ));

    expect(
      issues.map((issue) => issue.location.start.offset),
      equals([105, 208]),
    );
    expect(
      issues.map((issue) => issue.location.start.line),
      equals([15, 25]),
    );
    expect(
      issues.map((issue) => issue.location.start.column),
      equals([3, 3]),
    );
    expect(
      issues.map((issue) => issue.location.end.offset),
      equals([112, 246]),
    );
    expect(
      issues.map((issue) => issue.location.text),
      equals([
        'Test();',
        'set value(String str) => _value = str;',
      ]),
    );
    expect(
      issues.map((issue) => issue.message),
      equals([
        'constructors should be before public_fields',
        'public_setters should be before private_methods',
      ]),
    );
  });

  test('MemberOrdering for angular decorators reports about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');
    final parseResult = parseString(
      content: _angularContent,
      // ignore: deprecated_member_use
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    final config = {
      'order': [
        'angular_outputs',
        'angular_inputs',
        'angular_host_listeners',
        'angular_host_bindings',
        'angular_content_children',
        'angular_view_children',
        'constructors',
      ],
    };

    final issues =
        MemberOrderingRule(config: config).check(InternalResolvedUnitResult(
      sourceUrl,
      parseResult.content,
      parseResult.unit,
    ));

    expect(
      issues.map((issue) => issue.location.start.offset),
      equals([27, 61, 106, 148, 202, 230, 319]),
    );
    expect(
      issues.map((issue) => issue.location.start.line),
      equals([5, 8, 11, 14, 17, 20, 26]),
    );
    expect(
      issues.map((issue) => issue.location.start.column),
      equals([3, 3, 3, 3, 3, 3, 3]),
    );
    expect(
      issues.map((issue) => issue.location.end.offset),
      equals([57, 102, 142, 198, 226, 273, 361]),
    );
    expect(
      issues.map((issue) => issue.location.text),
      equals([
        "@ViewChild('')\n"
            '  Element view;',
        "@ViewChild('')\n"
            '  Iterable<Element> views;',
        "@ContentChild('')\n"
            '  Element content;',
        "@ContentChildren('')\n"
            '  Iterable<Element> contents;',
        '@Input()\n'
            '  String input;',
        '@Output()\n'
            '  Stream<void> get click => null;',
        "@HostListener('')\n"
            '  void handle() => null;',
      ]),
    );
    expect(
      issues.map((issue) => issue.message),
      equals([
        'angular_view_children should be before constructors',
        'angular_view_children should be before constructors',
        'angular_content_children should be before angular_view_children',
        'angular_content_children should be before angular_view_children',
        'angular_inputs should be before angular_content_children',
        'angular_outputs should be before angular_inputs',
        'angular_host_listeners should be before angular_host_bindings',
      ]),
    );
  });

  test('MemberOrdering with alphabetical order reports about found issues', () {
    final sourceUrl = Uri.parse('/example.dart');
    final parseResult = parseString(
      content: _alphabeticalContent,
      // ignore: deprecated_member_use
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    final config = {
      'alphabetize': true,
      'order': [
        'public_methods',
        'public_fields',
        'angular_inputs',
      ],
    };

    final issues =
        MemberOrderingRule(config: config).check(InternalResolvedUnitResult(
      sourceUrl,
      parseResult.content,
      parseResult.unit,
    ));

    expect(
      issues.map((issue) => issue.location.start.offset),
      equals([79, 101, 125, 36, 55, 101, 174]),
    );
    expect(
      issues.map((issue) => issue.location.start.line),
      equals([9, 13, 17, 5, 7, 13, 24]),
    );
    expect(
      issues.map((issue) => issue.location.start.column),
      equals([3, 3, 3, 3, 3, 3, 3]),
    );
    expect(
      issues.map((issue) => issue.location.end.offset),
      equals([97, 121, 143, 51, 75, 121, 198]),
    );
    expect(
      issues.map((issue) => issue.location.text),
      equals([
        'void work() {\n'
            '\n'
            '  }',
        'void create() {\n'
            '\n'
            '  }',
        'void init() {\n'
            '\n'
            '  }',
        'final data = 2;',
        'final algorithm = 3;',
        'void create() {\n'
            '\n'
            '  }',
        '@Input()\n'
            '  String first;',
      ]),
    );
    expect(
      issues.map((issue) => issue.message),
      equals([
        'public_methods should be before public_fields',
        'public_methods should be before public_fields',
        'public_methods should be before public_fields',
        'data should be alphabetically before value',
        'algorithm should be alphabetically before data',
        'create should be alphabetically before work',
        'first should be alphabetically before last',
      ]),
    );
  });
}
