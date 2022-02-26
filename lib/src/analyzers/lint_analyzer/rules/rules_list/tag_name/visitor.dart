part of 'tag_name_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _ParsedConfig _parsedConfig;

  _Visitor(this._parsedConfig);

  final _nodes = <_NodeWithMessage>[];

  Iterable<_NodeWithMessage> get nodes => _nodes;

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    super.visitFieldDeclaration(node);

    for (final fieldVariable in node.fields.variables) {
      _checkField(node, fieldVariable);
    }
  }

  void _checkField(FieldDeclaration node, VariableDeclaration fieldVariable) {
    final fieldName = fieldVariable.name.name;
    final fieldType = fieldVariable.declaredElement?.type;

    if (!(fieldType != null && fieldType.isDartCoreString && _parsedConfig.varNames.contains(fieldName))) {
      return;
    }

    final fieldInitializer = fieldVariable.initializer;
    if (fieldInitializer is! StringLiteral) {
      return;
    }
    final fieldInitValue = fieldInitializer.stringValue;

    final classDeclaration = node.thisOrAncestorOfType<ClassDeclaration>();
    final className = classDeclaration?.name.name;
    if (className == null) {
      return;
    }
    final expectFieldValue = className;

    if (fieldInitValue != expectFieldValue) {
      _nodes.add(_NodeWithMessage(
        fieldInitializer,
        Replacement(
          comment: "Replace with '$expectFieldValue'",
          replacement: "'$expectFieldValue'",
        ),
      ));
    }
  }
}

class _NodeWithMessage {
  final StringLiteral initializer;
  final Replacement replacement;

  _NodeWithMessage(this.initializer, this.replacement);
}
