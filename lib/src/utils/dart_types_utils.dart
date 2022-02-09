// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/element/type.dart';

bool isIterableOrSubclass(DartType? type) =>
    _isIterable(type) || _isSubclassOfIterable(type);

bool _isIterable(DartType? type) => type?.isDartCoreIterable ?? false;

bool _isSubclassOfIterable(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isIterable);

bool isListOrSubclass(DartType? type) =>
    _isList(type) || _isSubclassOfList(type);

bool _isList(DartType? type) => type?.isDartCoreList ?? false;

bool _isSubclassOfList(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isList);
