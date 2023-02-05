part of 'format_comment_rule.dart';

const _punctuation = ['.', '!', '?', ':'];

final _sentencesRegExp = RegExp(r'(?<=([\.|:](?=\s|\n|$)))');
final _regMacrosExp = RegExp('{@.+}');
const _ignoreExp = 'ignore:';
const _ignoreForFileExp = 'ignore_for_file:';

class _Visitor extends RecursiveAstVisitor<void> {
  final Iterable<RegExp> _ignoredPatterns;

  final bool _onlyDocComments;

  // ignore: avoid_positional_boolean_parameters
  _Visitor(this._ignoredPatterns, this._onlyDocComments);

  final _comments = <_CommentInfo>[];

  Iterable<_CommentInfo> get comments => _comments;

  @override
  void visitComment(Comment node) {
    super.visitComment(node);

    if (node.isDocumentation) {
      final isValid = node.tokens.length == 1
          ? _hasValidSingleLine(node.tokens.first, _CommentType.doc)
          : _hasValidMultiline(node.tokens, _CommentType.doc);
      if (!isValid) {
        _comments.add(_DocCommentInfo(node));
      }
    }
  }

  void checkRegularComments(AstNode node) {
    if (_onlyDocComments) {
      return;
    }

    Token? token = node.beginToken;
    while (token != null) {
      final extractedComments = <Token>[];

      Token? commentToken = token.precedingComments;
      while (commentToken != null) {
        if (_isRegularComment(commentToken)) {
          extractedComments.add(commentToken);
        }
        commentToken = commentToken.next;
      }

      if (extractedComments.isNotEmpty) {
        final isValid = extractedComments.length > 1
            ? _hasValidMultiline(extractedComments, _CommentType.regular)
            : _hasValidSingleLine(
                extractedComments.first,
                _CommentType.regular,
              );
        if (!isValid) {
          final notIgnored = extractedComments.where((comment) {
            final trimmed = comment
                .toString()
                .replaceAll(_CommentType.regular.pattern, '')
                .trim();

            return !_isIgnoreComment(trimmed) && !_isIgnoredPattern(trimmed);
          }).toList();
          _comments.add(_RegularCommentInfo(notIgnored));
        }

        extractedComments.clear();
      }

      if (token == token.next) {
        break;
      }

      token = token.next;
    }
  }

  bool _isRegularComment(Token commentToken) {
    final token = commentToken.toString();

    return !token.startsWith('///') && token.startsWith('//');
  }

  bool _hasValidMultiline(List<Token> commentTokens, _CommentType type) {
    final text = _extractText(commentTokens, type);
    final sentences = text.split(_sentencesRegExp);

    return sentences.every(_isValidSentence);
  }

  bool _hasValidSingleLine(Token commentToken, _CommentType type) {
    final commentText = commentToken.toString().substring(type.pattern.length);
    final text = commentText.trim();

    if (text.isEmpty ||
        _isIgnoreComment(text) ||
        _isMacros(text) ||
        _isIgnoredPattern(text)) {
      return true;
    }

    return _isValidSentence(commentText);
  }

  bool _isValidSentence(String sentence) {
    final trimmedSentence = sentence.trim();
    if (trimmedSentence.isEmpty) {
      return true;
    }

    final upperCase = trimmedSentence[0] == trimmedSentence[0].toUpperCase();
    final lastSymbol =
        _punctuation.contains(trimmedSentence[trimmedSentence.length - 1]);
    final hasEmptySpace = sentence[0] == ' ';

    return upperCase && lastSymbol && hasEmptySpace;
  }

  String _extractText(List<Token> commentTokens, _CommentType type) {
    var result = '';
    var shouldSkipNext = false;
    for (final token in commentTokens) {
      final commentText = token.toString().replaceAll(type.pattern, '');
      if (commentText.contains('```')) {
        shouldSkipNext = !shouldSkipNext;
      } else if (!_shouldSkip(commentText) && !shouldSkipNext) {
        result += commentText;
      }
    }

    return result;
  }

  bool _shouldSkip(String text) {
    final trimmed = text.trim();

    return _regMacrosExp.hasMatch(text) ||
        _isIgnoreComment(trimmed) ||
        _isIgnoredPattern(trimmed);
  }

  bool _isIgnoreComment(String text) =>
      text.startsWith(_ignoreExp) || text.startsWith(_ignoreForFileExp);

  bool _isMacros(String text) => _regMacrosExp.hasMatch(text);

  bool _isIgnoredPattern(String text) =>
      _ignoredPatterns.any((regExp) => regExp.hasMatch(text));
}

abstract class _CommentInfo {
  const _CommentInfo();
}

class _DocCommentInfo extends _CommentInfo {
  final Comment comment;

  const _DocCommentInfo(this.comment);
}

class _RegularCommentInfo extends _CommentInfo {
  final List<Token> tokens;

  const _RegularCommentInfo(this.tokens);
}

class _CommentType {
  final String pattern;

  const _CommentType(this.pattern);

  static const regular = _CommentType('//');
  static const doc = _CommentType('///');
}
