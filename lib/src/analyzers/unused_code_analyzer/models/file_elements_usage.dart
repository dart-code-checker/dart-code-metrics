import 'package:analyzer/dart/element/element.dart';

import 'prefix_element_usage.dart';

/// A container with information about used imports prefixes and used imported
/// elements.
class FileElementsUsage {
  /// The map of referenced prefix elements and the elements that they prefix.
  final Map<PrefixElement, PrefixElementUsage> prefixMap = {};

  /// The set of referenced top-level elements.
  final Set<Element> elements = {};

  /// The set of extensions defining members that are referenced.
  final Set<ExtensionElement> usedExtensions = {};

  final Set<String> exports = {};

  void merge(FileElementsUsage other) {
    prefixMap.addAll(other.prefixMap);
    elements.addAll(other.elements);
    usedExtensions.addAll(other.usedExtensions);
    exports.addAll(other.exports);
  }
}
