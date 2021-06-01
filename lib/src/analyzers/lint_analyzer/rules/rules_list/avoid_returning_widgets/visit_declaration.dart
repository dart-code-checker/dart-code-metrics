part of 'avoid_returning_widgets.dart';

Declaration? _visitDeclaration(
  Declaration node,
  SimpleIdentifier name,
  TypeAnnotation? returnType,
  Iterable<String> ignoredNames,
  Iterable<String> ignoredAnnotations, {
  required bool isSetter,
}) {
  final hasIgnoredAnnotation = node.metadata.any(
    (node) =>
        ignoredAnnotations.contains(node.name.name) &&
        node.atSign.type.lexeme == '@',
  );

  if (!hasIgnoredAnnotation &&
      !isSetter &&
      !_isIgnored(name.name, ignoredNames)) {
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
  Iterable<String> ignoredNames,
) =>
    name == 'build' || ignoredNames.contains(name);

bool _isWidget(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'Widget';

bool _isSubclassOfWidget(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isWidget);

bool _isSubclassOfWidgetState(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isWidgetState);

bool _isWidgetState(DartType? type) => type?.element?.displayName == 'State';
