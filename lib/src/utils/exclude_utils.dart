import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

bool isIncluded(String absolutePath, Iterable<Glob> includes) =>
    includes.isEmpty || _hasMatch(absolutePath, includes);

bool isExcluded(String absolutePath, Iterable<Glob> excludes) =>
    _hasMatch(absolutePath, excludes);

Iterable<Glob> createAbsolutePatterns(
  Iterable<String> patterns,
  String root,
) =>
    patterns
        .map((pattern) =>
            Glob(p.normalize(p.join(root, pattern)).replaceAll(r'\', '/')))
        .toList();

bool _hasMatch(String absolutePath, Iterable<Glob> excludes) {
  final path = absolutePath.replaceAll(r'\', '/');

  return excludes.any((exclude) => exclude.matches(path));
}
