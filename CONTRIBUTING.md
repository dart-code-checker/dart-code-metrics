# Contribution guide

## Creating new lint rule

To create a new rule:

1. Choose a rule name according to our naming guide or take it from existing issue for the rule.
2. Add an `.md` file with the rule documentation to `doc/rules`. If the rule supports configuration add ![Configurable](https://img.shields.io/badge/-configurable-informational) badge, if it has auto-fixes add ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success) badge
3. Create a rule `.dart` file under `lib/src/analyzers/lint_analyzer/rules/rules_list`.
4. Create a class that extends `Rule`. Add a public field with rule id, documentation url.

    The class constructor should take `Map<String, Object> config` parameter which represents config that is passed to the rule from the `analysis_options.yaml`. Example:

    ```dart
    BinaryExpressionOperandOrderRule([
        Map<String, Object> config = const {},
    ]) : super(
            id: ruleId,
            documentation: Uri.parse(_documentationUrl),
            severity: readSeverity(config, Severity.style),
        );
    ```

5. Add a visitor class which extends any of the base visitors. Usually you will need `RecursiveAstVisitor`. All visitors are [listed there](https://github.com/dart-lang/sdk/blob/master/pkg/analyzer/lib/dart/ast/visitor.dart). Visitor should be added to a separate file and imported with `part` directive.
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

9. Add the rule to the `lib/src/analyzers/lint_analyzer/rules/rules_factory.dart`. Example:

    ```dart
    final _implementedRules = <String, Rule Function(Map<String, Object>)>{
        ...
        BinaryExpressionOperandOrderRule.ruleId: (config) =>
      BinaryExpressionOperandOrderRule(config: config),
      ...
    }
    ```

10. Add the rule tests under `test/analyzers/lint_analyzer/rules/rules_list/`. Prefer to split test examples to a correct/incorrect groups.

## Run the plugin in IDE

The plugin works in multiple IDEs and is implemented as analysis server plugin. To work on and test IDE/analysis server integration features and issues you
will need to load the plugin into analysis server.

To set this up:

1. Clone the repository into `<absolute-path>` directory.
2. Change the plugin starter `dart_code_metrics` dependency in `tools\analyzer_plugin\pubspec.yaml` to a path dependency:

    ```yaml
    name: dart_code_metrics_plugin_loader
    description: This pubspec determines the version of the analyzer plugin to load.
    version: 4.0.0

    environment:
      sdk: '>=2.12.0 <3.0.0'

    dependencies:
      dart_code_metrics:
        path: <absolute-path>
    ```

3. Do the same in your project(s) you wish to work on `dart-code-metrics`: reference it from absolute path.
4. Run `dart pub get` in:
   - `dart_code_metrics` working copy
   - `tools\analyzer_plugin` directory in `dart_code_metrics` working copy
   - your project directory
5. For Visual Studio Code on Windows: delete `C:\Users\<your-windows-user-name>\AppData\Local\.dartServer` folder.
6. Start / restart your IDE
