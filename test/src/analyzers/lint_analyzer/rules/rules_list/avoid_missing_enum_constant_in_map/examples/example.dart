enum CountyCode {
  russia,
  kazachstan,
  another,
}

extension CountyTypeX on CountyCode {
  // LINT
  static const _code = <CountyCode, String>{
    CountyCode.russia: 'RUS',
    CountyCode.another: 'XXX',
  };

  // LINT
  static const _title = <CountyCode, String>{
    CountyCode.russia: 'Россия',
  };

  static CountyCode? fromCode(String? code) => enumDecodeNullable(_code, code);

  String get title => _title[this]!;

  String get code => _code[this]!;
}
