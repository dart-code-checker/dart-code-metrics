import 'package:intl/intl.dart';

class SomeButtonClassI18n {
// Static
  static final String staticFinalFieldInClassTitle = Intl.message(
    'static final field in class',
    name: 'SomeButtonClassI18n_staticFinalFieldInClass',
    args: <Object>[],
  );

  static String staticFieldInClassTitle = Intl.message(
    'static field in class',
    name: 'SomeButtonClassI18n_staticFieldInClass',
    args: <Object>[],
  );

  static String get staticPropertyWithBodyInClassTitle {
    return Intl.message(
      'static property with body in class',
      name: 'SomeButtonClassI18n_staticPropertyWithBodyInClass',
    );
  }

  static String get staticPropertyWithExpressionInClassTitle => Intl.message(
        'static property with expression in class',
        name: 'SomeButtonClassI18n_staticPropertyWithExpressionInClass',
      );

  static String staticMethodBodyInClassTitle() {
    return Intl.message(
      'static method with body in class',
      name: 'SomeButtonClassI18n_staticMethodBodyInClass',
    );
  }

  static String staticMethodExpressionInClassTitle() => Intl.message(
        'static method with expression in class',
        name: 'SomeButtonClassI18n_staticMethodExpressionInClass',
      );

// Instance
  final String finalFieldInClassTitle = Intl.message(
    'final field in class',
    name: 'SomeButtonClassI18n_finalFieldInClass',
    args: <Object>[],
  );

  String fieldInClassTitle = Intl.message(
    'field in class',
    args: <Object>[],
    name: 'SomeButtonClassI18n_fieldInClass',
  );

  String get propertyWithBodyInClassTitle {
    return Intl.message(
      'property with body in class',
      name: 'SomeButtonClassI18n_propertyWithBodyInClass',
    );
  }

  String get propertyWithExpressionInClassTitle => Intl.message(
        'property with expression in class',
        name: 'SomeButtonClassI18n_propertyWithExpressionInClass',
      );

  String methodBodyInClassTitle() {
    return Intl.message(
      'method with body in class',
      name: 'SomeButtonClassI18n_methodBodyInClass',
    );
  }

  String methodExpressionInClassTitle() => Intl.message(
        'method with expression in class',
        name: 'SomeButtonClassI18n_methodExpressionInClass',
      );
}

mixin SomeButtonMixinI18n {
  // Static
  static final String staticFinalFieldInMixinTitle = Intl.message(
    'static final field in mixin',
    args: <Object>[],
    name: 'SomeButtonMixinI18n_staticFinalFieldInMixin',
  );

  static String staticFieldInMixinTitle = Intl.message(
    'static field in mixin',
    args: <Object>[],
    name: 'SomeButtonMixinI18n_staticFieldInMixin',
  );

  static String get staticPropertyWithBodyInMixinTitle {
    return Intl.message(
      'static property with body in mixin',
      name: 'SomeButtonMixinI18n_staticPropertyWithBodyInMixin',
    );
  }

  static String get staticPropertyWithExpressionInMixinTitle => Intl.message(
        'static property with expression in mixin',
        name: 'SomeButtonMixinI18n_staticPropertyWithExpressionInMixin',
      );

  static String staticMethodBodyInMixinTitle() {
    return Intl.message(
      'static method with body in mixin',
      name: 'SomeButtonMixinI18n_staticMethodBodyInMixin',
    );
  }

  static String staticMethodExpressionInMixinTitle() => Intl.message(
        'static method with expression in mixin',
        name: 'SomeButtonMixinI18n_staticMethodExpressionInMixin',
      );

// Instance
  final String finalFieldInMixinTitle = Intl.message(
    'final field in mixin',
    args: <Object>[],
    name: 'SomeButtonMixinI18n_finalFieldInMixin',
  );

  String fieldInMixinTitle = Intl.message(
    'field in mixin',
    args: <Object>[],
    name: 'SomeButtonMixinI18n_fieldInMixin',
  );

  String get propertyWithBodyInMixinTitle {
    return Intl.message(
      'property with body in mixin',
      name: 'SomeButtonMixinI18n_propertyWithBodyInMixin',
    );
  }

  String get propertyWithExpressionInMixinTitle => Intl.message(
        'property with expression in mixin',
        name: 'SomeButtonMixinI18n_propertyWithExpressionInMixin',
      );

  String methodBodyInMixinTitle() {
    return Intl.message(
      'method with body in mixin',
      name: 'SomeButtonMixinI18n_methodBodyInMixin',
    );
  }

  String methodExpressionInMixinTitle() => Intl.message(
        'method with expression in mixin',
        name: 'SomeButtonMixinI18n_methodExpressionInMixin',
      );
}

extension ObjectExtensions on Object {
  // Static
  static String get staticPropertyWithBodyInExtensionsTitle {
    return Intl.message(
      'static property with body in extension',
      name: 'ObjectExtensions_staticPropertyWithBodyInExtensions',
    );
  }

  static String get staticPropertyWithExpressionInExtensionsTitle =>
      Intl.message(
        'static property with expression in extension',
        name: 'ObjectExtensions_staticPropertyWithExpressionInExtensions',
      );

  static String staticMethodBodyInExtensionsTitle() {
    return Intl.message(
      'static method with body in extension',
      name: 'ObjectExtensions_staticMethodBodyInExtensions',
    );
  }

  static String staticMethodExpressionInExtensionsTitle() => Intl.message(
        'static method with expression in extension',
        name: 'ObjectExtensions_staticMethodExpressionInExtensions',
      );

// Instance
  String get propertyWithBodyInExtensionsTitle {
    return Intl.message(
      'property with body in extension',
      name: 'ObjectExtensions_propertyWithBodyInExtensions',
    );
  }

  String get propertyWithExpressionInExtensionsTitle => Intl.message(
        'property with expression in extension',
        name: 'ObjectExtensions_propertyWithExpressionInExtensions',
      );

  String methodBodyInExtensionsTitle() {
    return Intl.message(
      'method with body in extension',
      name: 'ObjectExtensions_methodBodyInExtensions',
    );
  }

  String methodExpressionInExtensionsTitle() => Intl.message(
        'method with expression in extension',
        name: 'ObjectExtensions_methodExpressionInExtensions',
      );
}

final String finalFieldTitle = Intl.message(
  'final field',
  args: <Object>[],
  name: 'finalField',
);

String fieldTitle = Intl.message(
  'field',
  args: <Object>[],
  name: 'field',
);

String get propertyWithBodyTitle {
  return Intl.message(
    'property with body',
    name: 'propertyWithBody',
  );
}

String get propertyWithExpressionTitle => Intl.message(
      'property with expression',
      name: 'propertyWithExpression',
    );

String methodBodyTitle() {
  return Intl.message(
    'method with body',
    name: 'methodBody',
  );
}

String methodExpressionTitle() => Intl.message(
      'method with expression',
      name: 'methodExpression',
    );
