import 'package:mason/mason.dart';

import 'category.dart';

void run(HookContext context) {
  _overrideCategoryParameter(context);
}

void _overrideCategoryParameter(HookContext context) {
  const categoryKey = 'category';
  context.vars[categoryKey] =
      Category.fromString(context.vars[categoryKey].toString().toLowerCase())
          .valueInDcm;
}
