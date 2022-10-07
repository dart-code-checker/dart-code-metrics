part of 'avoid_missing_enum_constant_in_map_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _declarations = <_MapInfo>[];

  Iterable<_MapInfo> get declarations => _declarations;

  @override
  void visitSetOrMapLiteral(SetOrMapLiteral node) {
    super.visitSetOrMapLiteral(node);

    if (!node.isMap) {
      return;
    }

    final usages = <String>[];
    EnumElement? enumElement;

    for (final element in node.elements) {
      if (element is MapLiteralEntry) {
        final key = element.key;
        if (key is PrefixedIdentifier) {
          final staticElement = key.prefix.staticElement;
          if (staticElement is EnumElement) {
            enumElement ??= staticElement;
            usages.add(key.identifier.name);
          }
        }
      }
    }

    final parent = node.parent;
    final fields = enumElement?.fields;
    if (fields != null && parent != null) {
      for (final field in fields) {
        final name = field.displayName;
        if (field.isConst && !usages.contains(name) && name != 'values') {
          _declarations.add(_MapInfo(name, parent));
        }
      }
    }
  }
}

class _MapInfo {
  final AstNode parent;
  final String name;

  const _MapInfo(this.name, this.parent);
}
