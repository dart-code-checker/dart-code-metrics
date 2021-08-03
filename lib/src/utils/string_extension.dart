final _camelRegExp = RegExp('(?=[A-Z])');

/// Various useful string extensions.
extension StringExtensions on String {
  /// Returns a text from phrases in camel case.
  ///
  /// Example: print('camelCaseToText'.camelCaseToText()); => 'camel case to text'
  String camelCaseToText() => split(_camelRegExp).join(' ').toLowerCase();

  /// Returns a string with capitalized first character.
  ///
  /// Example: print('capitalize'.capitalize()); => 'Capitalize'
  String capitalize() => this[0].toUpperCase() + substring(1);

  /// Returns a string in kebab case
  ///
  /// Example: print('snake_case'.snakeCaseToKebab()); => 'snake-case'
  String snakeCaseToKebab() => replaceAll('_', '-');
}
