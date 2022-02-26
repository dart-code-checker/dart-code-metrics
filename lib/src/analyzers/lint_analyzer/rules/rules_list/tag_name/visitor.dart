part of 'tag_name_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _ParsedConfig _parsedConfig;

  _Visitor(this._parsedConfig);

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    super.visitFieldDeclaration(node);

    for (final fieldVariable in node.fields.variables) {
      final name = fieldVariable.name.name;
      if (_parsedConfig.varNames.contains(name)) {
        // TODO
        print('hi $name $node');
      }
    }
  }
}
