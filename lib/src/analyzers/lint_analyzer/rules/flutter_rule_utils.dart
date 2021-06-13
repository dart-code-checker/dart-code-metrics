import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';

bool hasWidgetType(DartType type) =>
    isWidgetOrSubclass(type) ||
    _isIterable(type) ||
    _isList(type) ||
    _isFuture(type);

bool isWidgetOrSubclass(DartType? type) =>
    _isWidget(type) || _isSubclassOfWidget(type);

bool isWidgetStateOrSubclass(DartType? type) =>
    _isWidgetState(type) || _isSubclassOfWidgetState(type);

bool isSubclassOfListenable(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isListenable);

bool isPaddingWidget(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'Padding';

bool _isWidget(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'Widget';

bool _isSubclassOfWidget(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isWidget);

bool _isWidgetState(DartType? type) => type?.element?.displayName == 'State';

bool _isSubclassOfWidgetState(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isWidgetState);

bool _isIterable(DartType type) =>
    type.isDartCoreIterable &&
    type is InterfaceType &&
    isWidgetOrSubclass(type.typeArguments.firstOrNull);

bool _isList(DartType type) =>
    type.isDartCoreList &&
    type is InterfaceType &&
    isWidgetOrSubclass(type.typeArguments.firstOrNull);

bool _isFuture(DartType type) =>
    type.isDartAsyncFuture &&
    type is InterfaceType &&
    isWidgetOrSubclass(type.typeArguments.firstOrNull);

bool _isListenable(DartType type) =>
    type.getDisplayString(withNullability: false) == 'Listenable';
