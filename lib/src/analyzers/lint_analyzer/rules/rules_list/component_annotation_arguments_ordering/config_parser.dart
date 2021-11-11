part of 'component_annotation_arguments_ordering_rule.dart';

class _ConfigParser {
  static const _orderConfig = 'order';

  static List<_ArgumentGroup> parseOrder(Map<String, Object> config) {
    final order = config[_orderConfig] is Iterable
        ? List<String>.from(config[_orderConfig] as Iterable)
        : <String>[];

    return order.isEmpty
        ? _ArgumentGroup._groupsOrder
        : order
            .map((group) => group.snakeCaseToKebab())
            .map(_ArgumentGroup.parseGroupName)
            .whereNotNull()
            .toList();
  }
}
