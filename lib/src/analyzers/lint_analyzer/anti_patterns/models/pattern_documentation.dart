import 'package:meta/meta.dart';

import '../../models/entity_type.dart';

/// Represents any pattern documentation
@immutable
class PatternDocumentation {
  /// The name of the pattern
  final String name;

  /// The type of entities which will be analyzed by the pattern.
  final EntityType supportedType;

  /// Initialize a newly created [PatternDocumentation].
  ///
  /// This data object is used for a documentation generating from a source code.
  const PatternDocumentation({required this.name, required this.supportedType});
}
