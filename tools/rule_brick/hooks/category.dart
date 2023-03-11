enum Category {
  common('CommonRule'),
  angular('AngularRule'),
  flame('FlameRule'),
  flutter('FlutterRule'),
  intl('IntlRule');

  final String valueInDcm;

  const Category(this.valueInDcm);

  static Category fromString(String name) => Category.values.firstWhere(
        (value) => value.name == name.toLowerCase(),
        orElse: () => Category.common,
      );
}
