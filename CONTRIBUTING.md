# Creating new lint rule

To create a new rule:

1. Choose a rule name according to our naming guide or take it from existing issue for the rule.
2. Add an `.md` file with the rule documentation to `doc/rules`. If the rule supports configuration add ![Configurable](https://img.shields.io/badge/-configurable-informational) badge, if it has auto-fixes add ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success) badge
3. Create a rule `.dart` file under `lib/src/rules/`.
4. Create a class that extends `Rule`. Add a public field with rule id, documentation url (use https://git.io/ to shorten url to the documentation file, created at step 2).

    The class constructor should take `Map<String, Object> config` parameter which represents config that is passed to the rule from the `analysis_options.yaml`. Example:

    ```dart
    BinaryExpressionOperandOrderRule({
        Map<String, Object> config = const {},
    }) : super(
            id: ruleId,
            documentation: Uri.parse(_documentationUrl),
            severity: readSeverity(config, Severity.style),
        );
    ```

5. Add a visitor class which extends any of the base visitors. Usually you will need `RecursiveAstVisitor`. All visitors are [listed there](https://github.com/dart-lang/sdk/blob/master/pkg/analyzer/lib/dart/ast/visitor.dart).
6. Add methods overrides to the visitor class for nodes that you want to check (ex. `visitBinaryExpression`, `visitBlock`).
7. Collect all data needed for the rule (we usually use a private field for data storage and public getter to access it from the `check` method).
8. In the rule class add override to `check` method. Create a visitor instance and visit all compilation unit children with it.

    Convert data to `Issue`'s and return them from the method. Example:

    ```dart
        @override
        Iterable<Issue> check(Source source) {
        final visitor = _Visitor();

        source.compilationUnit.visitChildren(visitor);

        return visitor.binaryExpressions
            .map((lit) => createIssue(
                this,
                nodeLocation(lit, source),
                _warningMessage,
                Replacement(
                    comment: _correctionComment,
                    replacement: '${lit.rightOperand} ${lit.operator} ${lit.leftOperand}',
                ),
            ))
            .toList(growable: false);
        }
    ```

9. Add the rule to the `lib/src/rules_factory.dart`. Example:

    ```dart
    final _implementedRules = <String, Rule Function(Map<String, Object>)>{
        ...
        BinaryExpressionOperandOrderRule.ruleId: (config) =>
      BinaryExpressionOperandOrderRule(config: config),
      ...
    }
    ```

10. Add the rule tests under `test/rules/`. Prefer to split test examples to a correct/incorrect groups.
