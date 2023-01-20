import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

/// A container with information about used imports prefixes and used imported
/// elements.
class InvocationsUsage {
  /// The set of referenced top-level elements.
  final Map<Element, Set<ArgumentList>?> elements = {};

  final Set<String> exports = {};

  void addElementUsage(Element element, Set<ArgumentList>? expressions) {
    elements.update(
      element,
      (value) {
        if (expressions == null || value == null) {
          return null;
        }

        return value..addAll(expressions);
      },
      ifAbsent: () => expressions,
    );
  }

  void merge(InvocationsUsage other) {
    other.elements.forEach(addElementUsage);
    exports.addAll(other.exports);
  }
}
