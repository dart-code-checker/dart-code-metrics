part of 'member_ordering.dart';

class _ConfigParser {
  static const _orderConfig = 'order';

  static List<_MembersGroup> parseOrder(Map<String, Object> config) {
    final order = config[_orderConfig] is Iterable
        ? List<String>.from(config[_orderConfig] as Iterable)
        : <String>[];

    return order.isEmpty
        ? _MembersGroup._groupsOrder
        : order
            .map((group) => group.snakeCaseToKebab())
            .map(_MembersGroup.parse)
            .whereNotNull()
            .toList();
  }

  static bool parseAlphabetize(Map<String, Object> config) =>
      (config['alphabetize'] as bool?) ?? false;
}
