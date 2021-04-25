import 'package:intl/intl.dart';
//Issues

class SomeButtonClassI18n {
// Static
  static final String staticFinalFieldInClassTitle = Intl.message(
    'static final field in class',
    args: <Object>[],
  );

  static String staticFieldInClassTitle = Intl.message(
    'static field in class',
    args: <Object>[],
  );

  static String get staticPropertyWithBodyInClassTitle {
    return Intl.message(
      'static property with body in class',
    );
  }

  static String get staticPropertyWithExpressionInClassTitle => Intl.message(
        'static property with expression in class',
      );

  static String staticMethodBodyInClassTitle() {
    return Intl.message(
      'static method with body in class',
    );
  }

  static String staticMethodExpressionInClassTitle() => Intl.message(
        'static method with expression in class',
      );

// Instance
  final String finalFieldInClassTitle = Intl.message(
    'final field in class',
    args: <Object>[],
  );

  String fieldInClassTitle = Intl.message(
    'field in class',
    args: <Object>[],
  );

  String get propertyWithBodyInClassTitle {
    return Intl.message(
      'property with body in class',
    );
  }

  String get propertyWithExpressionInClassTitle => Intl.message(
        'property with expression in class',
      );

  String methodBodyInClassTitle() {
    return Intl.message(
      'method with body in class',
    );
  }

  String methodExpressionInClassTitle() => Intl.message(
        'method with expression in class',
      );
}

mixin SomeButtonMixinI18n {
  // Static
  static final String staticFinalFieldInMixinTitle = Intl.message(
    'static final field in mixin',
    args: <Object>[],
  );

  static String staticFieldInMixinTitle = Intl.message(
    'static field in mixin',
    args: <Object>[],
  );

  static String get staticPropertyWithBodyInMixinTitle {
    return Intl.message(
      'static property with body in mixin',
    );
  }

  static String get staticPropertyWithExpressionInMixinTitle => Intl.message(
        'static property with expression in mixin',
      );

  static String staticMethodBodyInMixinTitle() {
    return Intl.message(
      'static method with body in mixin',
    );
  }

  static String staticMethodExpressionInMixinTitle() => Intl.message(
        'static method with expression in mixin',
      );

// Instance
  final String finalFieldInMixinTitle = Intl.message(
    'final field in mixin',
    args: <Object>[],
  );

  String fieldInMixinTitle = Intl.message(
    'field in mixin',
    args: <Object>[],
  );

  String get propertyWithBodyInMixinTitle {
    return Intl.message(
      'property with body in mixin',
    );
  }

  String get propertyWithExpressionInMixinTitle => Intl.message(
        'property with expression in mixin',
      );

  String methodBodyInMixinTitle() {
    return Intl.message(
      'method with body in mixin',
    );
  }

  String methodExpressionInMixinTitle() => Intl.message(
        'method with expression in mixin',
      );
}

extension ObjectExtensions on Object {
  // Static
  static String get staticPropertyWithExpressionInExtensionsTitle =>
      Intl.message(
        'static property with expression in extension',
      );

  static String staticMethodBodyInExtensionsTitle() {
    return Intl.message(
      'static method with body in extension',
    );
  }

  static String staticMethodExpressionInExtensionsTitle() => Intl.message(
        'static method with expression in extension',
      );

// Instance
  String get propertyWithExpressionInExtensionsTitle => Intl.message(
        'property with expression in extension',
      );

  String methodBodyInExtensionsTitle() {
    return Intl.message(
      'method with body in extension',
    );
  }

  String methodExpressionInExtensionsTitle() => Intl.message(
        'method with expression in extension',
      );
}

final String finalFieldTitle = Intl.message(
  'final field',
  args: <Object>[],
);

String fieldTitle = Intl.message(
  'field',
  args: <Object>[],
);

String get propertyWithBodyTitle {
  return Intl.message(
    'property with body',
  );
}

String get propertyWithExpressionTitle => Intl.message(
      'property with expression',
    );

String methodBodyTitle() {
  return Intl.message(
    'method with body',
  );
}

String methodExpressionTitle() => Intl.message(
      'method with expression',
    );
