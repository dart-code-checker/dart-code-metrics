// ignore_for_file: dead_code, unused_local_variable, no-empty-block

import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:test/test.dart';

// BlockFunctionBody
Stream<String> veryComplexFunction() async* {
  // AssertStatement
  assert(false, '');

  // CatchClause
  try {
    const a = 1;
  } on Exception catch (_, __) {
    const b = 1;
  } finally {
    const c = 1;
  }

  // ConditionalExpression
  const c = true ? 'true' : 'false';

  // ExpressionFunctionBody
  <Object>[].map((d) => null);

  // ForStatement
  for (final e in <Object>[]) {
    final ee = e;
  }

  // IfStatement
  if (c.isNotEmpty) {
    const cc = '$c$c';
  } else {
    const bb = '';
  }

  // SwitchDefault
  switch (c) {
    case 'a':
      break;
    default:
      break;
  }

  // WhileStatement
  while (c != null) {
    const cc = c;
  }

  yield c;

  // TokenType.AMPERSAND_AMPERSAND
  final d = c.isNotEmpty && true;

  // TokenType.BAR_BAR
  final e = c.isNotEmpty || false;

  // TokenType.QUESTION_PERIOD
  final f = c?.isNotEmpty;

  // TokenType.QUESTION_QUESTION
  final g = Object() ?? Object();

  // TokenType.QUESTION_QUESTION_EQ
  Object h;
  h ??= Object();
}

void visitBlock(Token firstToken, Token lastToken) {
  const tokenTypes = [
    TokenType.AMPERSAND_AMPERSAND,
    TokenType.BAR_BAR,
    TokenType.QUESTION_PERIOD,
    TokenType.QUESTION_QUESTION,
    TokenType.QUESTION_QUESTION_EQ,
  ];

  var token = firstToken;
  while (token != lastToken) {
    if (token.matchesAny(tokenTypes)) {
      _increaseComplexity(token);
    }

    token = token.next;
  }
}

void _increaseComplexity(SyntacticEntity entity) {}

void functionWithTest() {
  Calculator? calc;
  group('a', () {
    group('b', () {
      group('c', () {
        test('adds one to input values', () {
          calc = Calculator();
          expect(calc?.addOne(2), 3);
          expect(calc?.addOne(-7), -6);
          expect(calc?.addOne(0), 1);
        });
      });
    });
  });
}

class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
