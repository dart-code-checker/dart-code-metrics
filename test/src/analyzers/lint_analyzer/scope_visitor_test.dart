import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/scope_visitor.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/class_type.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/function_type.dart';
import 'package:test/test.dart';

import '../../helpers/file_resolver.dart';

const _abstractClassExample = './test/resources/abstract_class.dart';
const _classWithFactoryConstructorsExample =
    './test/resources/class_with_factory_constructors.dart';
const _extensionWithMethodExample = './test/resources/extension.dart';
const _functionsExample = './test/resources/functions.dart';
const _mixinExample = './test/resources/mixin.dart';
const _severalClassesExample = './test/resources/weight_of_class_example.dart';

void main() {
  group('ScopeVisitor collects scope from file with', () {
    late ScopeVisitor visitor;

    setUp(() {
      visitor = ScopeVisitor();
    });

    test('abstract class', () async {
      (await FileResolver.resolve(_abstractClassExample))
          .unit
          .visitChildren(visitor);

      final classDeclaration = visitor.classes.single;
      expect(classDeclaration.declaration, isA<ClassDeclaration>());
      expect(classDeclaration.type, equals(ClassType.generic));
      expect(classDeclaration.name, equals('Doer'));

      final function = visitor.functions.single;
      expect(function.type, equals(FunctionType.method));
      expect(function.name, equals('doSomething'));
      expect(function.fullName, equals('Doer.doSomething'));
    });

    test('class with factory constructors', () async {
      (await FileResolver.resolve(_classWithFactoryConstructorsExample))
          .unit
          .visitChildren(visitor);

      final classDeclaration = visitor.classes.single;
      expect(classDeclaration.declaration, isA<ClassDeclaration>());
      expect(classDeclaration.type, equals(ClassType.generic));
      expect(classDeclaration.name, equals('Logger'));

      final functions = visitor.functions.toList(growable: false);
      expect(functions, hasLength(4));

      final factoryConstructor = functions.first;
      expect(factoryConstructor.type, equals(FunctionType.constructor));
      expect(factoryConstructor.name, equals('Logger'));
      expect(factoryConstructor.fullName, equals('Logger.Logger'));

      final fromJson = functions[1];
      expect(fromJson.type, equals(FunctionType.constructor));
      expect(fromJson.name, equals('fromJson'));
      expect(fromJson.fullName, equals('Logger.fromJson'));

      final constructor = functions[2];
      expect(constructor.type, equals(FunctionType.constructor));
      expect(constructor.name, equals('_internal'));
      expect(constructor.fullName, equals('Logger._internal'));

      expect(functions.last.type, equals(FunctionType.method));
      expect(functions.last.name, equals('log'));
      expect(functions.last.fullName, equals('Logger.log'));
    });

    test('extension with method', () async {
      (await FileResolver.resolve(_extensionWithMethodExample))
          .unit
          .visitChildren(visitor);

      final classDeclaration = visitor.classes.single;
      expect(classDeclaration.declaration, isA<ExtensionDeclaration>());
      expect(classDeclaration.type, equals(ClassType.extension));
      expect(classDeclaration.name, equals('NumberParsing'));

      final function = visitor.functions.single;
      expect(function.type, equals(FunctionType.method));
      expect(function.name, equals('parseInt'));
      expect(function.fullName, equals('NumberParsing.parseInt'));
    });

    test('mixin', () async {
      (await FileResolver.resolve(_mixinExample)).unit.visitChildren(visitor);

      final classDeclaration = visitor.classes.single;
      expect(classDeclaration.declaration, isA<MixinDeclaration>());
      expect(classDeclaration.type, equals(ClassType.mixin));
      expect(classDeclaration.name, equals('Musical'));

      final function = visitor.functions.single;
      expect(function.type, equals(FunctionType.method));
      expect(function.name, equals('entertainMe'));
      expect(function.fullName, equals('Musical.entertainMe'));
    });

    test('functions', () async {
      (await FileResolver.resolve(_functionsExample))
          .unit
          .visitChildren(visitor);

      expect(visitor.classes, isEmpty);
      expect(visitor.functions, hasLength(2));

      expect(visitor.functions.first.type, equals(FunctionType.function));
      expect(visitor.functions.first.name, equals('printInteger'));
      expect(visitor.functions.first.fullName, equals('printInteger'));

      expect(visitor.functions.last.type, equals(FunctionType.function));
      expect(visitor.functions.last.name, equals('main'));
      expect(visitor.functions.last.fullName, equals('main'));
    });

    test('several classes', () async {
      (await FileResolver.resolve(_severalClassesExample))
          .unit
          .visitChildren(visitor);

      expect(visitor.classes, hasLength(3));

      expect(visitor.classes.first.declaration, isA<ClassDeclaration>());
      expect(visitor.classes.first.type, equals(ClassType.generic));
      expect(visitor.classes.first.name, equals('SimpleClass'));

      expect(visitor.classes.toList()[1].declaration, isA<ClassDeclaration>());
      expect(visitor.classes.toList()[1].type, equals(ClassType.generic));
      expect(visitor.classes.toList()[1].name, equals('Spacecraft'));

      expect(visitor.classes.last.declaration, isA<ClassDeclaration>());
      expect(visitor.classes.last.type, equals(ClassType.generic));
      expect(visitor.classes.last.name, equals('EmptyAbstractClass'));

      final functions = visitor.functions.toList(growable: false);
      expect(functions, hasLength(6));

      final constructor1 = functions.first;
      expect(constructor1.type, equals(FunctionType.constructor));
      expect(constructor1.name, equals('SimpleClass'));
      expect(constructor1.fullName, equals('SimpleClass.SimpleClass'));

      final lettersCount = functions[1];
      expect(lettersCount.type, equals(FunctionType.getter));
      expect(lettersCount.name, equals('lettersCount'));
      expect(lettersCount.fullName, equals('SimpleClass.lettersCount'));

      final constructor2 = functions[2];
      expect(constructor2.type, equals(FunctionType.constructor));
      expect(constructor2.name, equals('Spacecraft'));
      expect(constructor2.fullName, equals('Spacecraft.Spacecraft'));

      final unLaunched = functions[3];
      expect(unLaunched.type, equals(FunctionType.constructor));
      expect(unLaunched.name, equals('unLaunched'));
      expect(unLaunched.fullName, equals('Spacecraft.unLaunched'));

      final launchYear = functions[4];
      expect(launchYear.type, equals(FunctionType.getter));
      expect(launchYear.name, equals('launchYear'));
      expect(launchYear.fullName, equals('Spacecraft.launchYear'));

      final describe = functions[5];
      expect(describe.type, equals(FunctionType.method));
      expect(describe.name, equals('describe'));
      expect(describe.fullName, equals('Spacecraft.describe'));
    });
  });
}
