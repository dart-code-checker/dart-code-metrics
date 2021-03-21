class Logger {
  final String name;
  bool mute = false;

  // _cache is library-private, thanks to
  // the _ in front of its name.
  static final Map<String, Logger> _cache = <String, Logger>{};

  factory Logger(String name) =>
      _cache.putIfAbsent(name, () => Logger._internal(name));

  factory Logger.fromJson(Map<String, Object> json) =>
      Logger(json['name'].toString());

  Logger._internal(this.name);

  void log(String msg) {
    if (!mute) {
      print(msg);
    }
  }
}
