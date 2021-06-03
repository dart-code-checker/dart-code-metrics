import 'package:glob/glob.dart';

class UnusedFilesConfig {
  final Iterable<Glob> globalExcludes;

  const UnusedFilesConfig(this.globalExcludes);
}
