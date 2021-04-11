import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';

import '../../models/issue.dart';
import '../../models/severity.dart';
import '../../utils/node_utils.dart';
import '../../utils/rule_utils.dart';
import 'obsolete_rule.dart';

class AvoidReturningWidgets extends ObsoleteRule {
  static const String ruleId = 'avoid-returning-widgets';
  static const _documentationUrl = '';

  static const _warningMessage = 'Avoid returning widgets from a function';

  static const _ignoredNamesConfig = 'ignored-names';

  final Iterable<String> _ignoredNames;

  AvoidReturningWidgets({Map<String, Object> config = const {}})
      : _ignoredNames = _getIgnoredNames(config),
        super(
          id: ruleId,
          documentationUrl: Uri.parse(_documentationUrl),
          severity: readSeverity(config, Severity.warning),
        );

  @override
  Iterable<Issue> check(ResolvedUnitResult source) {
    final _visitor = _Visitor(_ignoredNames);

    source.unit?.visitChildren(_visitor);

    return _visitor.declarations
        .map((declaration) => createIssue(
              rule: this,
              location: nodeLocation(
                node: declaration,
                source: source,
                withCommentOrMetadata: true,
              ),
              message: _warningMessage,
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
      _isWidget(type) ||
      _isSubclassOfWidget(type) ||
      _isIterable(type) ||
      _isList(type) ||
      _isFuture(type);

  bool _isIterable(DartType type) =>
      type.isDartCoreIterable &&
      type is InterfaceType &&
      (_isWidget(type.typeArguments.firstOrNull) ||
          _isSubclassOfWidget(type.typeArguments.firstOrNull));

  bool _isList(DartType type) =>
      type.isDartCoreList &&
      type is InterfaceType &&
      (_isWidget(type.typeArguments.firstOrNull) ||
          _isSubclassOfWidget(type.typeArguments.firstOrNull));

  bool _isFuture(DartType type) =>
      type.isDartAsyncFuture &&
      type is InterfaceType &&
      (_isWidget(type.typeArguments.firstOrNull) ||
          _isSubclassOfWidget(type.typeArguments.firstOrNull));

  bool _isWidget(DartType? type) =>
      type?.getDisplayString(withNullability: false) == 'Widget';

  bool _isSubclassOfWidget(DartType? type) =>
      type is InterfaceType &&
      type.allSupertypes.firstWhereOrNull(_isWidget) != null;

  bool _isIgnored(String name) =>
      name == 'build' || _ignoredNames.contains(name);
}
