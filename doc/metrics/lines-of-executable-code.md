# Lines of Executable Code *(**deprecated**, will be removed in 3.3 version)*

**Lines of Executable Code** is the approximate number of executable code lines or operations in a function or method. Blank or comment lines are not counted. Function with high values of this metric are often complex and tough to maintain.

Example:

```dart
Iterable<Issue> check(
    CompilationUnit unit, Uri sourceUrl, String sourceContent) {
  final _visitor = _Visitor();

  unit.visitChildren(_visitor);

  return _visitor.statements
      // return statement is in a block
      .where((statement) =>
          statement.parent != null && statement.parent is Block)
      // return statement isn't first token in a block
      .where((statement) =>
          statement.returnKeyword.previous != statement.parent.beginToken)
      .where((statement) {
        final previousTokenLine = unit.lineInfo
            .getLocation(statement.returnKeyword.previous.end)
            .lineNumber;
        final tokenLine = unit.lineInfo
            .getLocation(
                _optimalToken(statement.returnKeyword, unit.lineInfo).offset)
            .lineNumber;

        return !(tokenLine > previousTokenLine + 1);
      })
      .map((statement) => createIssue(this, _failure, null, null, sourceUrl,
          sourceContent, unit.lineInfo, statement))
      .toList(growable: false);
}
```

**Lines of Executable Code** for the example function is **20**.
