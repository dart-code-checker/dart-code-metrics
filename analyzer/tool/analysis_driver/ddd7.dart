import 'dart:io' as io;

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/src/dart/analysis/performance_logger.dart';

main() async {
  ResourceProvider resourceProvider = PhysicalResourceProvider.INSTANCE;

  var rootPath = '/Users/scheglov/dart/test/bin';
  var collection = AnalysisContextCollectionImpl(
    includedPaths: [rootPath],
    resourceProvider: resourceProvider,
    sdkPath: '/Users/scheglov/Applications/dart-sdk',
    performanceLog: PerformanceLog(io.stdout),
  );

  var analysisContext = collection.contextFor(
    '/Users/scheglov/dart/test/bin/test.dart',
  );
  var resultUnit = await analysisContext.currentSession.getResolvedUnit(
    '/Users/scheglov/dart/test/bin/test.dart',
  );
  resultUnit as ResolvedUnitResult;

  resultUnit.unit.accept(
    _Visitor(),
  );
}

class _Visitor extends RecursiveAstVisitor<void> {
  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    var element = node.staticElement!;
    print('[element: $element][enclosing: ${element.enclosingElement}]');

    var canonicalElement = _canonicalizeElement(element)!;
    print(
      '[canonicalElement: $canonicalElement]'
      '[enclosing: ${canonicalElement.enclosingElement}]',
    );
  }

  Element? _canonicalizeElement(Element element) {
    Element? canonicalElement = element;
    if (canonicalElement is FieldFormalParameterElement) {
      canonicalElement = canonicalElement.field;
    } else if (canonicalElement is PropertyAccessorElement) {
      canonicalElement = canonicalElement.variable;
    }
    return canonicalElement?.declaration;
  }
}
