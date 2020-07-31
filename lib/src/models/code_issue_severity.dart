class CodeIssueSeverity {
  static const style = CodeIssueSeverity('style');
  static const warning = CodeIssueSeverity('warning');

  static const _all = [style, warning];

  final String value;

  const CodeIssueSeverity(this.value);

  static CodeIssueSeverity fromJson(String severity) => severity != null
      ? _all.firstWhere((val) => val.value == severity.toLowerCase(),
          orElse: () => null)
      : null;
}
