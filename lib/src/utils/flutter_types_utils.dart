// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';

bool hasWidgetType(DartType type) =>
    (isWidgetOrSubclass(type) ||
        _isIterable(type) ||
        _isList(type) ||
        _isFuture(type)) &&
    !(_isMultiProvider(type) ||
        _isSubclassOfInheritedProvider(type) ||
        _isIterableInheritedProvider(type) ||
        _isListInheritedProvider(type) ||
        _isFutureInheritedProvider(type));

bool isWidgetOrSubclass(DartType? type) =>
    _isWidget(type) || _isSubclassOfWidget(type);

bool isRenderObjectOrSubclass(DartType? type) =>
    _isRenderObject(type) || _isSubclassOfRenderObject(type);

bool isRenderObjectWidgetOrSubclass(DartType? type) =>
    _isRenderObjectWidget(type) || _isSubclassOfRenderObjectWidget(type);

bool isRenderObjectElementOrSubclass(DartType? type) =>
    _isRenderObjectElement(type) || _isSubclassOfRenderObjectElement(type);

bool isWidgetStateOrSubclass(DartType? type) =>
    _isWidgetState(type) || _isSubclassOfWidgetState(type);

bool isSubclassOfListenable(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isListenable);

bool isListViewWidget(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'ListView';

bool isSingleChildScrollViewWidget(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'SingleChildScrollView';

bool isColumnWidget(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'Column';

bool isRowWidget(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'Row';

bool isPaddingWidget(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'Padding';

bool isBuildContext(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'BuildContext';

bool isGameWidget(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'GameWidget';

bool _isWidget(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'Widget';

bool _isSubclassOfWidget(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isWidget);

// ignore: deprecated_member_use
bool _isWidgetState(DartType? type) => type?.element2?.displayName == 'State';

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

bool _isRenderObject(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'RenderObject';

bool _isSubclassOfRenderObject(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isRenderObject);

bool _isRenderObjectWidget(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'RenderObjectWidget';

bool _isSubclassOfRenderObjectWidget(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isRenderObjectWidget);

bool _isRenderObjectElement(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'RenderObjectElement';

bool _isSubclassOfRenderObjectElement(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isRenderObjectElement);

bool _isMultiProvider(DartType? type) =>
    type?.getDisplayString(withNullability: false) == 'MultiProvider';

bool _isSubclassOfInheritedProvider(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isInheritedProvider);

bool _isInheritedProvider(DartType? type) =>
    type != null &&
    type
        .getDisplayString(withNullability: false)
        .startsWith('InheritedProvider<');

bool _isIterableInheritedProvider(DartType type) =>
    type.isDartCoreIterable &&
    type is InterfaceType &&
    _isSubclassOfInheritedProvider(type.typeArguments.firstOrNull);

bool _isListInheritedProvider(DartType type) =>
    type.isDartCoreList &&
    type is InterfaceType &&
    _isSubclassOfInheritedProvider(type.typeArguments.firstOrNull);

bool _isFutureInheritedProvider(DartType type) =>
    type.isDartAsyncFuture &&
    type is InterfaceType &&
    _isSubclassOfInheritedProvider(type.typeArguments.firstOrNull);
