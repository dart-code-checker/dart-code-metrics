class OrderExample {
  String publicField;

  String get string => publicField.toString();

  set string(String newString) => publicField = newString;

  String _privateField = '42';

  String get _field => _privateField;

  set _field(String newString) => _privateField = '42';
}
