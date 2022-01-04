import 'package:analyzer/dart/ast/token.dart';

import 'comment_type.dart';

class CommentInfo {
  final Token token;
  final CommentType type;

  CommentInfo(this.type, this.token);
}
