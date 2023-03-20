import 'package:analyzer/dart/element/element.dart';

/// A container with information about used imports prefixes and used imported
/// elements.
class FileElementsUsage {
  /// The set of referenced top-level elements.
  final Set<Element> elements = {};

  /// The set of extensions defining members that are referenced.
  final Set<ExtensionElement> usedExtensions = {};

  final Set<String> exports = {};

  final Map<Set<String>, Set<Element>> conditionalElements = {};

  void merge(FileElementsUsage other) {
    elements.addAll(other.elements);
    usedExtensions.addAll(other.usedExtensions);
    exports.addAll(other.exports);
    conditionalElements.addAll(other.conditionalElements);
  }
}
