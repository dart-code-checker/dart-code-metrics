import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

Iterable<Glob> prepareExcludes(Iterable<String> patterns, String root) =>
    patterns
        .map((exclude) => Glob(p.join(root, exclude).replaceAll(r'\', '/')))
        .toList();
