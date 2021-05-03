import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_checker/checker.dart';
import 'package:code_checker/rules.dart';

class AvoidReturningWidgets extends Rule {
  static const String ruleId = 'avoid-returning-widgets';
  static const _documentationUrl = 'https://git.io/JOmR1';

  static const _warningMessage = 'Avoid returning widgets from a function';

  static const _ignoredNamesConfig = 'ignored-names';

  final Iterable<String> _ignoredNames;

  AvoidReturningWidgets({Map<String, Object> config = const {}})
      : _ignoredNames = _getIgnoredNames(config),
        super(
          id: ruleId,
          documentation: Uri.parse(_documentationUrl),
          severity: readSeverity(config, Severity.warning),
        );

  @override
  Iterable<Issue> check(ProcessedFile file) {
    final _visitor = _Visitor(_ignoredNames);

    file.parsedContent.visitChildren(_visitor);

    return _visitor.declarations
        .map((declaration) => createIssue(
              this,
              nodeLocation(
                node: declaration,
                source: file,
                withCommentOrMetadata: true,
              ),
              _warningMessage,
              null,
            ))
        .toList(growable: false);
  }

  static Iterable<String> _getIgnoredNames(Map<String, Object> config) =>
      config.containsKey(_ignoredNamesConfig) &&
              config[_ignoredNamesConfig] is Iterable
          ? List<String>.from(config[_ignoredNamesConfig] as Iterable)
          : <String>[];
}

class _Visitor extends RecursiveAstVisitor<void> {
  final _declarations = <Declaration>[];

  final Iterable<String> _ignoredNames;

  Iterable<Declaration> get declarations => _declarations;

  _Visitor(this._ignoredNames);

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    super.visitMethodDeclaration(node);

    if (!node.isGetter && !node.isSetter && !_isIgnored(node.name.name)) {
      final type = node.returnType?.type;
      if (type != null && _hasWidgetType(type)) {
        _declarations.add(node);
      }
    }
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    super.visitFunctionDeclaration(node);

    if (!node.isGetter && !node.isSetter && !_isIgnored(node.name.name)) {
      final type = node.returnType?.type;
      if (type != null && _hasWidgetType(type)) {
        _declarations.add(node);
      }
    }
  }

  bool _hasWidgetType(DartType type) =>
      _isWidget([type]) ||
      _isSubclassOfWidget([type]) ||
      _isIterable(type) ||
      _isList(type) ||
      _isFuture(type);

  bool _isIterable(DartType type) =>
      type.getDisplayString(withNullability: false).startsWith('Iterable') &&
      type is InterfaceType &&
      (_isWidget(type.typeArguments) ||
          _isSubclassOfWidget(type.typeArguments));

  bool _isList(DartType type) =>
      type.isDartCoreList &&
      type is InterfaceType &&
      (_isWidget(type.typeArguments) ||
          _isSubclassOfWidget(type.typeArguments));

  bool _isFuture(DartType type) =>
      type.isDartAsyncFuture &&
      type is InterfaceType &&
      (_isWidget(type.typeArguments) ||
          _isSubclassOfWidget(type.typeArguments));

  bool _isWidget(Iterable<DartType> types) =>
      (types.isNotEmpty
          ? types.first.getDisplayString(withNullability: false)
          : null) ==
      'Widget';

  bool _isSubclassOfWidget(Iterable<DartType> types) =>
      types.isNotEmpty &&
      types.first is InterfaceType &&
      (types.first as InterfaceType)
              .element
              .allSupertypes
              .firstWhere((type) => _isWidget([type]), orElse: () => null) !=
          null;

  bool _isIgnored(String name) =>
      name == 'build' || _ignoredNames.contains(name);
}
