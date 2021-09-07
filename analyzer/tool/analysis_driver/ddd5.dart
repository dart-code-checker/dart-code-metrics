import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/analysis/analysis_context_collection.dart';

main() async {
  ResourceProvider resourceProvider = PhysicalResourceProvider.INSTANCE;
  // var analyzer = '/Users/scheglov/Source/Dart/sdk.git/sdk/pkg/analyzer';
  var analyzer =
      '/Users/scheglov/dart/json_serializable.dart/json_serializable';
  var collection = AnalysisContextCollectionImpl(
    includedPaths: [analyzer],
    resourceProvider: resourceProvider,
    sdkPath: '/Users/scheglov/Applications/dart-sdk',
  );

  var session = collection.contextFor(analyzer).currentSession;

  await session.getResolvedUnit(
      '/Users/scheglov/Applications/dart-sdk/lib/core/iterator.dart');
}
