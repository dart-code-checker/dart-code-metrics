// ignore_for_file: public_member_api_docs
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type_provider.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/line_info.dart';

// ignonre: non_abstract_class_inherits_abstract_member
class InternalResolvedUnitResult extends ResolvedUnitResult {
  final Uri _sourceUri;
  final String _content;
  final CompilationUnit _unit;

  @override
  String get content => _content;

  @override
  LibraryElement get libraryElement => null;

  @override
  TypeProvider get typeProvider => null;

  @override
  TypeSystem get typeSystem => null;

  @override
  CompilationUnit get unit => _unit;

  @override
  ResultState get state => null;

  @override
  List<AnalysisError> get errors => [];

  @override
  bool get isPart => false;

  @override
  LineInfo get lineInfo => null;

  @override
  String get path => _sourceUri.toString();

  @override
  AnalysisSession get session => null;

  @override
  Uri get uri => _sourceUri;

  InternalResolvedUnitResult(this._sourceUri, this._content, this._unit);
}
