import 'package:source_span/source_span.dart';

/// Represents a message with a relevant information associated with a diagnostic.
class ContextMessage {
  /// The message to be displayed to the user.
  final String message;

  /// The source location associated with or referenced by the message.
  final SourceSpan location;

  /// Initialize a newly created [ContextMessage] with the given [message] and [location].
  const ContextMessage({
    required this.message,
    required this.location,
  });
}
