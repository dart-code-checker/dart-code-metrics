import 'package:analyzer/dart/analysis/results.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

bool isExcluded(AnalysisResult result, Iterable<Glob> excludes) {
  final path = result.path?.replaceAll(r'\', '/');

  return path != null && excludes.any((exclude) => exclude.matches(path));
}

Iterable<Glob> prepareExcludes(Iterable<String> patterns, String root) =>
    patterns
        .map((exclude) => Glob(p.join(root, exclude).replaceAll(r'\', '/')))
        .toList();
