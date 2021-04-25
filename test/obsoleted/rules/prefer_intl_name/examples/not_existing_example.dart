import 'package:intl/intl.dart';
//Issues

class SomeButtonClassI18n {
  // Static

  // LINT
  static final String staticFinalFieldInClassTitle = Intl.message(
    'static final field in class',
    args: <Object>[],
  );

  // LINT
  static String staticFieldInClassTitle = Intl.message(
    'static field in class',
    args: <Object>[],
  );

  static String get staticPropertyWithBodyInClassTitle {
    // LINT
    return Intl.message(
      'static property with body in class',
    );
  }

  // LINT
  static String get staticPropertyWithExpressionInClassTitle => Intl.message(
        'static property with expression in class',
      );

  static String staticMethodBodyInClassTitle() {
    // LINT
    return Intl.message(
      'static method with body in class',
    );
  }

  // LINT
  static String staticMethodExpressionInClassTitle() => Intl.message(
        'static method with expression in class',
      );

  // Instance

  // LINT
  final String finalFieldInClassTitle = Intl.message(
    'final field in class',
    args: <Object>[],
  );

  // LINT
  String fieldInClassTitle = Intl.message(
    'field in class',
    args: <Object>[],
  );

  String get propertyWithBodyInClassTitle {
    // LINT
    return Intl.message(
      'property with body in class',
    );
  }

  // LINT
  String get propertyWithExpressionInClassTitle => Intl.message(
        'property with expression in class',
      );

  String methodBodyInClassTitle() {
    // LINT
    return Intl.message(
      'method with body in class',
    );
  }

  // LINT
  String methodExpressionInClassTitle() => Intl.message(
        'method with expression in class',
      );
}

mixin SomeButtonMixinI18n {
  // Static

  // LINT
  static final String staticFinalFieldInMixinTitle = Intl.message(
    'static final field in mixin',
    args: <Object>[],
  );

  // LINT
  static String staticFieldInMixinTitle = Intl.message(
    'static field in mixin',
    args: <Object>[],
  );

  static String get staticPropertyWithBodyInMixinTitle {
    // LINT
    return Intl.message(
      'static property with body in mixin',
    );
  }

  // LINT
  static String get staticPropertyWithExpressionInMixinTitle => Intl.message(
        'static property with expression in mixin',
      );

  static String staticMethodBodyInMixinTitle() {
    // LINT
    return Intl.message(
      'static method with body in mixin',
    );
  }

  // LINT
  static String staticMethodExpressionInMixinTitle() => Intl.message(
        'static method with expression in mixin',
      );

  // Instance

  // LINT
  final String finalFieldInMixinTitle = Intl.message(
    'final field in mixin',
    args: <Object>[],
  );

  // LINT
  String fieldInMixinTitle = Intl.message(
    'field in mixin',
    args: <Object>[],
  );

  String get propertyWithBodyInMixinTitle {
    // LINT
    return Intl.message(
      'property with body in mixin',
    );
  }

  // LINT
  String get propertyWithExpressionInMixinTitle => Intl.message(
        'property with expression in mixin',
      );

  String methodBodyInMixinTitle() {
    // LINT
    return Intl.message(
      'method with body in mixin',
    );
  }

  // LINT
  String methodExpressionInMixinTitle() => Intl.message(
        'method with expression in mixin',
      );
}

extension ObjectExtensions on Object {
  // Static

  static String get staticPropertyWithExpressionInExtensionsTitle =>
      // LINT
      Intl.message(
        'static property with expression in extension',
      );

  static String staticMethodBodyInExtensionsTitle() {
    // LINT
    return Intl.message(
      'static method with body in extension',
    );
  }

  // LINT
  static String staticMethodExpressionInExtensionsTitle() => Intl.message(
        'static method with expression in extension',
      );

  // Instance

  // LINT
  String get propertyWithExpressionInExtensionsTitle => Intl.message(
        'property with expression in extension',
      );

  String methodBodyInExtensionsTitle() {
    // LINT
    return Intl.message(
      'method with body in extension',
    );
  }

  // LINT
  String methodExpressionInExtensionsTitle() => Intl.message(
        'method with expression in extension',
      );
}

// LINT
final String finalFieldTitle = Intl.message(
  'final field',
  args: <Object>[],
);

// LINT
String fieldTitle = Intl.message(
  'field',
  args: <Object>[],
);

String get propertyWithBodyTitle {
  // LINT
  return Intl.message(
    'property with body',
  );
}

// LINT
String get propertyWithExpressionTitle => Intl.message(
      'property with expression',
    );

String methodBodyTitle() {
  // LINT
  return Intl.message(
    'method with body',
  );
}

// LINT
String methodExpressionTitle() => Intl.message(
      'method with expression',
    );
