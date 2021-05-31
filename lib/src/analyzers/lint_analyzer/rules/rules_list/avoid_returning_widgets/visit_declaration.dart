part of 'avoid_returning_widgets.dart';

Declaration? _visitDeclaration(
  Declaration node,
  SimpleIdentifier name,
  TypeAnnotation? returnType,
  Iterable<String> _ignoredNames,
  Iterable<String> _ignoredAnnotations, {
  required bool isSetter,
}) {
  final hasIgnoredAnnotation = node.metadata.firstWhereOrNull(
        (node) =>
            _ignoredAnnotations.contains(node.name.name) &&
            node.atSign.type.lexeme == '@',
      ) !=
      null;

  if (!hasIgnoredAnnotation &&
      !isSetter &&
      !_isIgnored(name.name, _ignoredNames)) {
    final type = returnType?.type;
    if (type != null && _hasWidgetType(type)) {
      return node;
    }
  }

  return null;
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

bool _isIgnored(
  String name,
  Iterable<String> _ignoredNames,
) =>
    name == 'build' || _ignoredNames.contains(name);

bool _isWidget(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'Widget';

bool _isSubclassOfWidget(DartType? type) =>
    type is InterfaceType &&
    type.allSupertypes.firstWhereOrNull(_isWidget) != null;

bool _isSubclassOfWidgetState(DartType? type) =>
    type is InterfaceType &&
    type.allSupertypes.firstWhereOrNull(_isWidgetState) != null;

bool _isWidgetState(DartType? type) => type?.element?.displayName == 'State';
