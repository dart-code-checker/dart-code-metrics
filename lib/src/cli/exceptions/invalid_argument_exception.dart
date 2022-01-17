/// Exception thrown when an arguments not pass validation.
class InvalidArgumentException implements Exception {
  /// Detailed message of what happened.
  final String message;

  /// Initialize a newly created [InvalidArgumentException].
  ///
  /// The passed [message] helps user figure out in aproblem.
  const InvalidArgumentException(this.message);
}
