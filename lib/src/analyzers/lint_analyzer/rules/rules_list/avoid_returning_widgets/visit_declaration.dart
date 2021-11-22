part of 'avoid_returning_widgets_rule.dart';

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
        node.atSign.type == TokenType.AT,
  );

  if (!hasIgnoredAnnotation &&
      !isSetter &&
      !_isIgnored(name.name, ignoredNames)) {
    final type = returnType?.type;
    if (type != null && hasWidgetType(type)) {
      return node;
    }
  }

  return null;
}

bool _isIgnored(
  String name,
  Iterable<String> ignoredNames,
) =>
    name == 'build' || ignoredNames.contains(name);
