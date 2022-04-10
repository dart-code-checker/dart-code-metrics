import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

bool isExcluded(String? absolutePath, Iterable<Glob> excludes) {
  final path = absolutePath?.replaceAll(r'\', '/');

  return path != null && excludes.any((exclude) => exclude.matches(path));
}

Iterable<Glob> prepareExcludes(
  Iterable<String> patterns,
  String root,
) =>
    patterns
        .map((exclude) =>
            Glob(p.normalize(p.join(root, exclude)).replaceAll(r'\', '/')))
        .toList();
