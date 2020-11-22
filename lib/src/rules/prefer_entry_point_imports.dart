import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart';

import '../models/code_issue.dart';
import '../models/code_issue_severity.dart';
import '../models/source.dart';
import 'base_rule.dart';
import 'rule_utils.dart';

class PreferEntryPointImports extends BaseRule {
  static const String ruleId = 'prefer-entry-point-imports';
  static const _documentationUrl = 'https://git.io/JkVcZ';

  static const _warningMessage =
      'Prefer entry point import instead of implementation import';

  PreferEntryPointImports({Map<String, Object> config = const {}})
      : super(
            id: ruleId,
            documentation: Uri.parse(_documentationUrl),
            severity:
                CodeIssueSeverity.fromJson(config['severity'] as String) ??
                    CodeIssueSeverity.warning);

  @override
  Iterable<CodeIssue> check(Source source) {
    final _visitor = _Visitor();

    source.compilationUnit.visitChildren(_visitor);

    return _visitor.directives
        .map(
          (directive) => createIssue(
            this,
            _warningMessage,
            null,
            null,
            source.url,
            source.content,
            source.compilationUnit.lineInfo,
            directive,
          ),
        )
        .toList(growable: false);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  static const _srcSegment = 'src';

  final _directives = <ImportDirective>[];

  Iterable<ImportDirective> get directives => _directives;

  _Visitor();

  @override
  void visitImportDirective(ImportDirective node) {
    super.visitImportDirective(node);

    final importUri = node?.uriSource?.uri;
    final sourceUri = node?.element?.source?.uri;

    if (sourceUri == null ||
        _isPackage(sourceUri) &&
            (sourceUri.pathSegments?.contains('test') ?? false) ||
        (node?.uriSource?.isInSystemLibrary ?? true)) {
      return;
    }

    if (_isPackage(importUri) && _isImplementationImport(importUri) ||
        !_isPackage(importUri) &&
            relative(importUri.toFilePath(), from: sourceUri.toFilePath())
                .contains(_srcSegment)) {
      _directives.add(node);
    }
  }

  bool _isImplementationImport(Uri uri) {
    final segments = uri?.pathSegments ?? const <String>[];

    return segments.length > 2 && segments[1] == _srcSegment;
  }

  bool _isPackage(Uri uri) => uri?.scheme == 'package';
}
