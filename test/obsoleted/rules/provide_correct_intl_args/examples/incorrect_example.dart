import 'package:intl/intl.dart';

class SomeButtonClassI18n {
  static const int value = 0;
  static const String name = 'name';

  static String simpleTitleNotExistArgsIssue(String name) {
    return Intl.message(
      'title',
      name: 'SomeButtonClassI18n_simpleTitleNotExistArgsIssue',
    );
  }

  static String simpleTitleArgsMustBeOmittedIssue1() {
    return Intl.message('title $name',
        name: 'SomeButtonClassI18n_simpleTitleArgsMustBeOmittedIssue1',
        args: [name]);
  }

  static String simpleTitleArgsMustBeOmittedIssue2() {
    return Intl.message('title',
        name: 'SomeButtonClassI18n_simpleTitleArgsMustBeOmittedIssue2',
        args: [name]);
  }

  static String simpleArgsItemMustBeOmittedIssue(int value) {
    return Intl.message('title $value',
        name: 'SomeButtonClassI18n_simpleArgsItemMustBeOmittedIssue',
        args: [value, name]);
  }

  static String simpleParameterMustBeOmittedIssue(String name, int value) {
    return Intl.message('title $value',
        name: 'SomeButtonClassI18n_simpleParameterMustBeOmittedIssue',
        args: [value, name]);
  }

  static String simpleMustBeSimpleIdentifierIssue1(int value) {
    return Intl.message('title ${value + 1}',
        name: 'SomeButtonClassI18n_simpleMustBeSimpleIdentifierIssue1',
        args: [value]);
  }

  static String simpleMustBeSimpleIdentifierIssue2(int value) {
    return Intl.message('title $value',
        name: 'SomeButtonClassI18n_simpleMustBeSimpleIdentifierIssue2',
        args: [value + 1]);
  }

  static String simpleParameterMustBeInArgsIssue(int value, String name) {
    return Intl.message('title $value, name: $name',
        name: 'SomeButtonClassI18n_simpleParameterMustBeInArgsIssue',
        args: [value]);
  }

  static String simpleArgsMustBeInParameterIssue(int value) {
    return Intl.message('title $value, name: $name',
        name: 'SomeButtonClassI18n_simpleArgsMustBeInParameterIssue',
        args: [value, name]);
  }

  static String simpleInterpolationMustBeInArgsIssue(int value, String name) {
    return Intl.message('title $value, name: $name',
        name: 'SomeButtonClassI18n_simpleInterpolationMustBeInArgsIssue',
        args: [value]);
  }

  static String simpleInterpolationMustBeInParameterIssue(int value) {
    return Intl.message('title $value, name: $name',
        name: 'SomeButtonClassI18n_simpleInterpolationMustBeInParameterIssue',
        args: [value, name]);
  }
}
