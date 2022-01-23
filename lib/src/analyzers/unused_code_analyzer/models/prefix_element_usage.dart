import 'package:analyzer/dart/element/element.dart';

/// A container with information about used imports prefixes.
class PrefixElementUsage {
  /// The paths to imported files.
  /// Used for conditional imports to track all conditional paths.
  final Iterable<String> paths;

  /// The set of referenced elements.
  final Set<Element> elements;

  const PrefixElementUsage(this.paths, this.elements);

  void add(Element element) {
    elements.add(element);
  }
}
