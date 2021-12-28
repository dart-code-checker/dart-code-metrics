import 'package:analyzer/dart/ast/token.dart';

class CommentInfo {
  final Token token;
  final String type;

  CommentInfo(this.type, this.token);
}
