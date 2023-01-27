import 'package:analyzer/dart/element/type.dart';

bool isComponentOrSubclass(DartType? type) =>
    _isComponent(type) || _isSubclassOfComponent(type);

bool _isComponent(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'Component';

bool _isSubclassOfComponent(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isComponent);
