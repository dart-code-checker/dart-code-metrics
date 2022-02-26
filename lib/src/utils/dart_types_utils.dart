// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';

bool isIterableOrSubclass(DartType? type) =>
    _checkSelfOrSupertypes(type, (t) => t?.isDartCoreIterable ?? false);

bool isListOrSubclass(DartType? type) =>
    _checkSelfOrSupertypes(type, (t) => t?.isDartCoreList ?? false);

bool isMapOrSubclass(DartType? type) =>
    _checkSelfOrSupertypes(type, (t) => t?.isDartCoreMap ?? false);

DartType? getSupertypeIterable(DartType? type) =>
    _getSelfOrSupertypes(type, (t) => t?.isDartCoreIterable ?? false);

DartType? getSupertypeList(DartType? type) =>
    _getSelfOrSupertypes(type, (t) => t?.isDartCoreList ?? false);

DartType? getSupertypeSet(DartType? type) =>
    _getSelfOrSupertypes(type, (t) => t?.isDartCoreSet ?? false);

DartType? getSupertypeMap(DartType? type) =>
    _getSelfOrSupertypes(type, (t) => t?.isDartCoreMap ?? false);

bool _checkSelfOrSupertypes(
  DartType? type,
  bool Function(DartType?) predicate,
) =>
    predicate(type) ||
    (type is InterfaceType && type.allSupertypes.any(predicate));

DartType? _getSelfOrSupertypes(
  DartType? type,
  bool Function(DartType?) predicate,
) {
  if (predicate(type)) {
    return type;
  }
  if (type is InterfaceType) {
    return type.allSupertypes.firstWhereOrNull(predicate);
  }

  return null;
}
