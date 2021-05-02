import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';

class InternalResolvedUnitResult extends ResolvedUnitResult {
  final Uri _sourceUri;
  final String _content;
  final CompilationUnit _unit;

  @override
  String get content => _content;

  @override
  CompilationUnit get unit => _unit;

  @override
  List<AnalysisError> get errors => [];

  @override
  String get path => _sourceUri.toString();

  @override
  Uri get uri => _sourceUri;

  InternalResolvedUnitResult(this._sourceUri, this._content, this._unit);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
