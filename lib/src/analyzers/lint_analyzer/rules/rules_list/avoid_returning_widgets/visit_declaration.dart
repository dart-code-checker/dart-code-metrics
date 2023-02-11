part of 'avoid_returning_widgets_rule.dart';

// ignore: long-parameter-list
Declaration? _visitDeclaration(
  Declaration node,
  String name,
  TypeAnnotation? returnType,
  Iterable<String> ignoredNames,
  Iterable<String> ignoredAnnotations, {
  required bool isSetter,
  required bool allowNullable,
}) {
  final hasIgnoredAnnotation = node.metadata.any(
    (node) =>
        ignoredAnnotations.contains(node.name.name) &&
        node.atSign.type == TokenType.AT,
  );

  if (!hasIgnoredAnnotation &&
      !isSetter &&
      !_isIgnored(name, ignoredNames) &&
      _hasWidgetType(returnType?.type, allowNullable)) {
    return node;
  }

  return null;
}

bool _isIgnored(
  String name,
  Iterable<String> ignoredNames,
) =>
    name == 'build' || ignoredNames.contains(name);

bool _hasWidgetType(DartType? type, bool allowNullable) =>
    type != null &&
    hasWidgetType(type) &&
    (!allowNullable || (allowNullable && !isNullableType(type)));
