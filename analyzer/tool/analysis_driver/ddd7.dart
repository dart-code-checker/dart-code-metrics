import 'dart:io' as io;

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/src/dart/analysis/performance_logger.dart';
import 'package:watcher/watcher.dart';

main() async {
  ResourceProvider resourceProvider = PhysicalResourceProvider.INSTANCE;

  var rootPath = '/Users/scheglov/Source/flutter/packages/flutter/lib';
  var collection = AnalysisContextCollectionImpl(
    includedPaths: [rootPath],
    resourceProvider: resourceProvider,
    sdkPath: '/Users/scheglov/Applications/dart-sdk',
    performanceLog: PerformanceLog(io.stdout),
  );

  var analysisContext = collection.contextFor(rootPath);
  analysisContext.driver.results.listen((event) {
    if (event is ErrorsResult) {
      print('[errors][path: ${event.path}]');
    } else {
      print('[results][event: ${event.runtimeType}]');
    }
  });

  for (var path in analysisContext.contextRoot.analyzedFiles()) {
    if (path.endsWith('.dart')) {
      print('[add][path: $path]');
      analysisContext.driver.addFile(path);
    }
  }

  resourceProvider.getFolder(rootPath).changes.listen((event) {
    if (event.type == ChangeType.MODIFY) {
      print('[change][path: ${event.path}]');
      analysisContext.driver.changeFile(event.path);
    }
  });

  // var filePath = '$analyzer/lib/src/dart/element/class_hierarchy.dart';
  // var filePath = '$analyzer/lib/src/dart/analysis/testing_data.dart';
  // var filePath = '$analyzer/lib/test.dart';
  // var filePath = '/Users/scheglov/Source/flutter/packages/flutter/lib/src/material/chip.dart';
  // for (var i = 0; i < 1000000; i++) {
  //   var timer = Stopwatch()..start();
  //   for (var i = 0; i < 100; i++) {
  //     analysisContext.driver.changeFile('/1.dart');
  //     // analysisContext.driver.changeFile(filePath);
  //     var session = analysisContext.currentSession;
  //     await session.getResolvedUnit(filePath);
  //   }
  //   print('[$i] time: ${timer.elapsedMilliseconds} ms.');
  // }
}
