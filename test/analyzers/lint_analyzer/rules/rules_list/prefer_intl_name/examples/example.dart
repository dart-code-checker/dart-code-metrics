import 'package:intl/intl.dart';

class SomeButtonClassI18n {
// Static
  static final String staticFinalFieldInClassTitle = Intl.message(
    'static final field in class',
    name: 'SomeButtonClassI18n_staticFinalFieldInClassTitle',
    args: <Object>[],
  );

  static String staticFieldInClassTitle = Intl.message(
    'static field in class',
    name: 'SomeButtonClassI18n_staticFieldInClassTitle',
    args: <Object>[],
  );

  static String get staticPropertyWithBodyInClassTitle {
    return Intl.message(
      'static property with body in class',
      name: 'SomeButtonClassI18n_staticPropertyWithBodyInClassTitle',
    );
  }

  static String get staticPropertyWithExpressionInClassTitle => Intl.message(
        'static property with expression in class',
        name: 'SomeButtonClassI18n_staticPropertyWithExpressionInClassTitle',
      );

  static String staticMethodBodyInClassTitle() {
    return Intl.message(
      'static method with body in class',
      name: 'SomeButtonClassI18n_staticMethodBodyInClassTitle',
    );
  }

  static String staticMethodExpressionInClassTitle() => Intl.message(
        'static method with expression in class',
        name: 'SomeButtonClassI18n_staticMethodExpressionInClassTitle',
      );

// Instance
  final String finalFieldInClassTitle = Intl.message(
    'final field in class',
    name: 'SomeButtonClassI18n_finalFieldInClassTitle',
    args: <Object>[],
  );

  String fieldInClassTitle = Intl.message(
    'field in class',
    args: <Object>[],
    name: 'SomeButtonClassI18n_fieldInClassTitle',
  );

  String get propertyWithBodyInClassTitle {
    return Intl.message(
      'property with body in class',
      name: 'SomeButtonClassI18n_propertyWithBodyInClassTitle',
    );
  }

  String get propertyWithExpressionInClassTitle => Intl.message(
        'property with expression in class',
        name: 'SomeButtonClassI18n_propertyWithExpressionInClassTitle',
      );

  String methodBodyInClassTitle() {
    return Intl.message(
      'method with body in class',
      name: 'SomeButtonClassI18n_methodBodyInClassTitle',
    );
  }

  String methodExpressionInClassTitle() => Intl.message(
        'method with expression in class',
        name: 'SomeButtonClassI18n_methodExpressionInClassTitle',
      );
}

mixin SomeButtonMixinI18n {
  // Static
  static final String staticFinalFieldInMixinTitle = Intl.message(
    'static final field in mixin',
    args: <Object>[],
    name: 'SomeButtonMixinI18n_staticFinalFieldInMixinTitle',
  );

  static String staticFieldInMixinTitle = Intl.message(
    'static field in mixin',
    args: <Object>[],
    name: 'SomeButtonMixinI18n_staticFieldInMixinTitle',
  );

  static String get staticPropertyWithBodyInMixinTitle {
    return Intl.message(
      'static property with body in mixin',
      name: 'SomeButtonMixinI18n_staticPropertyWithBodyInMixinTitle',
    );
  }

  static String get staticPropertyWithExpressionInMixinTitle => Intl.message(
        'static property with expression in mixin',
        name: 'SomeButtonMixinI18n_staticPropertyWithExpressionInMixinTitle',
      );

  static String staticMethodBodyInMixinTitle() {
    return Intl.message(
      'static method with body in mixin',
      name: 'SomeButtonMixinI18n_staticMethodBodyInMixinTitle',
    );
  }

  static String staticMethodExpressionInMixinTitle() => Intl.message(
        'static method with expression in mixin',
        name: 'SomeButtonMixinI18n_staticMethodExpressionInMixinTitle',
      );

// Instance
  final String finalFieldInMixinTitle = Intl.message(
    'final field in mixin',
    args: <Object>[],
    name: 'SomeButtonMixinI18n_finalFieldInMixinTitle',
  );

  String fieldInMixinTitle = Intl.message(
    'field in mixin',
    args: <Object>[],
    name: 'SomeButtonMixinI18n_fieldInMixinTitle',
  );

  String get propertyWithBodyInMixinTitle {
    return Intl.message(
      'property with body in mixin',
      name: 'SomeButtonMixinI18n_propertyWithBodyInMixinTitle',
    );
  }

  String get propertyWithExpressionInMixinTitle => Intl.message(
        'property with expression in mixin',
        name: 'SomeButtonMixinI18n_propertyWithExpressionInMixinTitle',
      );

  String methodBodyInMixinTitle() {
    return Intl.message(
      'method with body in mixin',
      name: 'SomeButtonMixinI18n_methodBodyInMixinTitle',
    );
  }

  String methodExpressionInMixinTitle() => Intl.message(
        'method with expression in mixin',
        name: 'SomeButtonMixinI18n_methodExpressionInMixinTitle',
      );
}

extension ObjectExtensions on Object {
  // Static
  static String get staticPropertyWithBodyInExtensionsTitle {
    return Intl.message(
      'static property with body in extension',
      name: 'ObjectExtensions_staticPropertyWithBodyInExtensionsTitle',
    );
  }

  static String get staticPropertyWithExpressionInExtensionsTitle =>
      Intl.message(
        'static property with expression in extension',
        name: 'ObjectExtensions_staticPropertyWithExpressionInExtensionsTitle',
      );

  static String staticMethodBodyInExtensionsTitle() {
    return Intl.message(
      'static method with body in extension',
      name: 'ObjectExtensions_staticMethodBodyInExtensionsTitle',
    );
  }

  static String staticMethodExpressionInExtensionsTitle() => Intl.message(
        'static method with expression in extension',
        name: 'ObjectExtensions_staticMethodExpressionInExtensionsTitle',
      );

// Instance
  String get propertyWithBodyInExtensionsTitle {
    return Intl.message(
      'property with body in extension',
      name: 'ObjectExtensions_propertyWithBodyInExtensionsTitle',
    );
  }

  String get propertyWithExpressionInExtensionsTitle => Intl.message(
        'property with expression in extension',
        name: 'ObjectExtensions_propertyWithExpressionInExtensionsTitle',
      );

  String methodBodyInExtensionsTitle() {
    return Intl.message(
      'method with body in extension',
      name: 'ObjectExtensions_methodBodyInExtensionsTitle',
    );
  }

  String methodExpressionInExtensionsTitle() => Intl.message(
        'method with expression in extension',
        name: 'ObjectExtensions_methodExpressionInExtensionsTitle',
      );
}

final String finalFieldTitle = Intl.message(
  'final field',
  args: <Object>[],
  name: 'finalFieldTitle',
);

String fieldTitle = Intl.message(
  'field',
  args: <Object>[],
  name: 'fieldTitle',
);

String get propertyWithBodyTitle {
  return Intl.message(
    'property with body',
    name: 'propertyWithBodyTitle',
  );
}

String get propertyWithExpressionTitle => Intl.message(
      'property with expression',
      name: 'propertyWithExpressionTitle',
    );

String methodBodyTitle() {
  return Intl.message(
    'method with body',
    name: 'methodBodyTitle',
  );
}

String methodExpressionTitle() => Intl.message(
      'method with expression',
      name: 'methodExpressionTitle',
    );
