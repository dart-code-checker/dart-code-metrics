import 'package:intl/intl.dart';

class SomeButtonClassI18n {
  // Static

  static final String staticFinalFieldInClassTitle = Intl.message(
    'static final field in class',
    name: 'SomeButtonClassI18n_staticFinalFieldInClass', // LINT
    args: <Object>[],
  );

  static String staticFieldInClassTitle = Intl.message(
    'static field in class',
    name: 'SomeButtonClassI18n_staticFieldInClass', // LINT
    args: <Object>[],
  );

  static String get staticPropertyWithBodyInClassTitle {
    return Intl.message(
      'static property with body in class',
      name: 'SomeButtonClassI18n_staticPropertyWithBodyInClass', // LINT
    );
  }

  static String get staticPropertyWithExpressionInClassTitle => Intl.message(
        'static property with expression in class',
        name: 'SomeButtonClassI18n_staticPropertyWithExpressionInClass', // LINT
      );

  static String staticMethodBodyInClassTitle() {
    return Intl.message(
      'static method with body in class',
      name: 'SomeButtonClassI18n_staticMethodBodyInClass', // LINT
    );
  }

  static String staticMethodExpressionInClassTitle() => Intl.message(
        'static method with expression in class',
        name: 'SomeButtonClassI18n_staticMethodExpressionInClass', // LINT
      );

  // Instance

  final String finalFieldInClassTitle = Intl.message(
    'final field in class',
    name: 'SomeButtonClassI18n_finalFieldInClass', // LINT
    args: <Object>[],
  );

  String fieldInClassTitle = Intl.message(
    'field in class',
    args: <Object>[],
    name: 'SomeButtonClassI18n_fieldInClass', // LINT
  );

  String get propertyWithBodyInClassTitle {
    return Intl.message(
      'property with body in class',
      name: 'SomeButtonClassI18n_propertyWithBodyInClass', // LINT
    );
  }

  String get propertyWithExpressionInClassTitle => Intl.message(
        'property with expression in class',
        name: 'SomeButtonClassI18n_propertyWithExpressionInClass', // LINT
      );

  String methodBodyInClassTitle() {
    return Intl.message(
      'method with body in class',
      name: 'SomeButtonClassI18n_methodBodyInClass', // LINT
    );
  }

  String methodExpressionInClassTitle() => Intl.message(
        'method with expression in class',
        name: 'SomeButtonClassI18n_methodExpressionInClass', // LINT
      );
}

mixin SomeButtonMixinI18n {
  // Static

  static final String staticFinalFieldInMixinTitle = Intl.message(
    'static final field in mixin',
    args: <Object>[],
    name: 'SomeButtonMixinI18n_staticFinalFieldInMixin', // LINT
  );

  static String staticFieldInMixinTitle = Intl.message(
    'static field in mixin',
    args: <Object>[],
    name: 'SomeButtonMixinI18n_staticFieldInMixin', // LINT
  );

  static String get staticPropertyWithBodyInMixinTitle {
    return Intl.message(
      'static property with body in mixin',
      name: 'SomeButtonMixinI18n_staticPropertyWithBodyInMixin', // LINT
    );
  }

  static String get staticPropertyWithExpressionInMixinTitle => Intl.message(
        'static property with expression in mixin',
        name: 'SomeButtonMixinI18n_staticPropertyWithExpressionInMixin', // LINT
      );

  static String staticMethodBodyInMixinTitle() {
    return Intl.message(
      'static method with body in mixin',
      name: 'SomeButtonMixinI18n_staticMethodBodyInMixin', // LINT
    );
  }

  static String staticMethodExpressionInMixinTitle() => Intl.message(
        'static method with expression in mixin',
        name: 'SomeButtonMixinI18n_staticMethodExpressionInMixin', // LINT
      );

  // Instance

  final String finalFieldInMixinTitle = Intl.message(
    'final field in mixin',
    args: <Object>[],
    name: 'SomeButtonMixinI18n_finalFieldInMixin', // LINT
  );

  String fieldInMixinTitle = Intl.message(
    'field in mixin',
    args: <Object>[],
    name: 'SomeButtonMixinI18n_fieldInMixin', // LINT
  );

  String get propertyWithBodyInMixinTitle {
    return Intl.message(
      'property with body in mixin',
      name: 'SomeButtonMixinI18n_propertyWithBodyInMixin', // LINT
    );
  }

  String get propertyWithExpressionInMixinTitle => Intl.message(
        'property with expression in mixin',
        name: 'SomeButtonMixinI18n_propertyWithExpressionInMixin', // LINT
      );

  String methodBodyInMixinTitle() {
    return Intl.message(
      'method with body in mixin',
      name: 'SomeButtonMixinI18n_methodBodyInMixin', // LINT
    );
  }

  String methodExpressionInMixinTitle() => Intl.message(
        'method with expression in mixin',
        name: 'SomeButtonMixinI18n_methodExpressionInMixin', // LINT
      );
}

extension ObjectExtensions on Object {
  // Static

  static String get staticPropertyWithBodyInExtensionsTitle {
    return Intl.message(
      'static property with body in extension',
      name: 'ObjectExtensions_staticPropertyWithBodyInExtensions', // LINT
    );
  }

  static String get staticPropertyWithExpressionInExtensionsTitle =>
      Intl.message(
        'static property with expression in extension',
        name:
            'ObjectExtensions_staticPropertyWithExpressionInExtensions', // LINT
      );

  static String staticMethodBodyInExtensionsTitle() {
    return Intl.message(
      'static method with body in extension',
      name: 'ObjectExtensions_staticMethodBodyInExtensions', // LINT
    );
  }

  static String staticMethodExpressionInExtensionsTitle() => Intl.message(
        'static method with expression in extension',
        name: 'ObjectExtensions_staticMethodExpressionInExtensions', // LINT
      );

  // Instance

  String get propertyWithBodyInExtensionsTitle {
    return Intl.message(
      'property with body in extension',
      name: 'ObjectExtensions_propertyWithBodyInExtensions', // LINT
    );
  }

  String get propertyWithExpressionInExtensionsTitle => Intl.message(
        'property with expression in extension',
        name: 'ObjectExtensions_propertyWithExpressionInExtensions', // LINT
      );

  String methodBodyInExtensionsTitle() {
    return Intl.message(
      'method with body in extension',
      name: 'ObjectExtensions_methodBodyInExtensions', // LINT
    );
  }

  String methodExpressionInExtensionsTitle() => Intl.message(
        'method with expression in extension',
        name: 'ObjectExtensions_methodExpressionInExtensions', // LINT
      );
}

final String finalFieldTitle = Intl.message(
  'final field',
  args: <Object>[],
  name: 'finalField', // LINT
);

String fieldTitle = Intl.message(
  'field',
  args: <Object>[],
  name: 'field', // LINT
);

String get propertyWithBodyTitle {
  return Intl.message(
    'property with body',
    name: 'propertyWithBody', // LINT
  );
}

String get propertyWithExpressionTitle => Intl.message(
      'property with expression',
      name: 'propertyWithExpression', // LINT
    );

String methodBodyTitle() {
  return Intl.message(
    'method with body',
    name: 'methodBody', // LINT
  );
}

String methodExpressionTitle() => Intl.message(
      'method with expression',
      name: 'methodExpression', // LINT
    );
