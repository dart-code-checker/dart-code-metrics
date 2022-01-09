---
sidebar_label: Overview
sidebar_position: 0
---

# Rules overview

Rules are grouped by a category to help you understand their purpose.

Rules configuration is [described here](../getting-started/configuration#configuring-a-rules-entry).

## Common {#common}

- [avoid-global-state](./common/avoid-global-state.md)

    Warns about usage mutable global variables.

- [avoid-ignoring-return-values](./common/avoid-ignoring-return-values.md)

    Warns when a return value of a method or function invocation or a class instance property access is not used.

- [avoid-late-keyword](./common/avoid-late-keyword.md)

    Warns when a field or variable is declared with a `late` keyword.

- [avoid-missing-enum-constant-in-map](./common/avoid-missing-enum-constant-in-map.md)

    Warns when a enum constant is missing in a map declaration.

- [avoid-nested-conditional-expressions](./common/avoid-nested-conditional-expressions.md) &nbsp; [![Configurable](https://img.shields.io/badge/-configurable-informational)](./common/member-ordering.md#config-example)

    Warns about nested conditional expressions.

- [avoid-non-null-assertion](./common/avoid-non-null-assertion.md)

    Warns when non null assertion operator (or “bang” operator) is used for a property access or method invocation. The operator check works at runtime and it may fail and throw a runtime exception.

- [avoid-throw-in-catch-block](./common/avoid-throw-in-catch-block.md)

    Warns when call `throw` in a catch block.

- [avoid-unnecessary-type-assertions](./common/avoid-unnecessary-type-assertions.md)

    Warns about unnecessary usage of 'is' and 'whereType' operators.

- [avoid-unnecessary-type-casts](./common/avoid-unnecessary-type-casts.md)

    Warns about unnecessary usage of 'as' operators.

- [avoid-unrelated-type-assertions](./common/avoid-unrelated-type-assertions.md)

    Warns about unrelated usages of 'is' operators.

- [avoid-unused-parameters](./common/avoid-unused-parameters.md)

    Checks for unused parameters inside a function or method body.

- [binary-expression-operand-order](./common/binary-expression-operand-order.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

    Warns when a literal value is on the left hand side in a binary expressions.

- [double-literal-format](./common/double-literal-format.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

    Checks that double literals should begin with `0.` instead of just `.`, and should not end with a trailing `0`.

- [member-ordering](./common/member-ordering.md) &nbsp; [![Configurable](https://img.shields.io/badge/-configurable-informational)](./common/member-ordering.md#config-example)

    Enforces ordering for a class members.

- [member-ordering-extended](./common/member-ordering-extended.md) &nbsp; [![Configurable](https://img.shields.io/badge/-configurable-informational)](./common/member-ordering-extended.md#config-example)

    Enforces ordering for a class members.

- [newline-before-return](./common/newline-before-return.md)

    Enforces blank line between statements and return in a block.

- [no-boolean-literal-compare](./common/no-boolean-literal-compare.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

    Warns on comparison to a boolean literal, as in x == true.

- [no-empty-block](./common/no-empty-block.md)

    Disallows empty blocks except catch clause block.

- [no-equal-arguments](./common/no-equal-arguments.md) &nbsp; ![Configurable](https://img.shields.io/badge/-configurable-informational)

    Warns when equal arguments passed to a function or method invocation.

- [no-equal-then-else](./common/no-equal-then-else.md)

    Warns when if statement has equal then and else statements or conditional expression has equal then and else expressions.

- [no-magic-number](./common/no-magic-number.md) &nbsp; [![Configurable](https://img.shields.io/badge/-configurable-informational)](./common/no-magic-number.md#config-example)

    Warns against using number literals outside of named constants or variables.

- [no-object-declaration](./common/no-object-declaration.md)

    Warns when a class member is declared with Object type.

- [prefer-conditional-expressions](./common/prefer-conditional-expressions.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

    Recommends to use a conditional expression instead of assigning to the same thing or return statement in each branch of an if statement.

- [prefer-correct-identifier-length](./common/prefer-correct-identifier-length.md) &nbsp; [![Configurable](https://img.shields.io/badge/-configurable-informational)](./common/prefer-correct-identifier-length.md#config-example)

    Warns when identifier name length very short or long.

- [prefer-correct-type-name](./common/prefer-correct-type-name.md) &nbsp; [![Configurable](https://img.shields.io/badge/-configurable-informational)](./common/prefer-correct-type-name.md#config-example)

    Type name should only contain alphanumeric characters, start with an uppercase character and span between min-length and max-length characters in length.

- [prefer-first](./common/prefer-first.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

    Use `first` to gets the first element.

- [prefer-last](./common/prefer-last.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

    Use `last` to gets the last element.

- [prefer-match-file-name](common/prefer-match-file-name.md)

    Warns when file name does not match class name.

- [prefer-trailing-comma](./common/prefer-trailing-comma.md) &nbsp; [![Configurable](https://img.shields.io/badge/-configurable-informational)](./common/prefer-trailing-comma.md#config-example) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

    Check for trailing comma for arguments, parameters, enum values and collections.

## Flutter specific {#flutter-specific}

- [always-remove-listener](./flutter/always-remove-listener.md)

    Warns when an event listener is added but never removed.

- [avoid-returning-widgets](./flutter/avoid-returning-widgets.md) &nbsp; [![Configurable](https://img.shields.io/badge/-configurable-informational)](./flutter/avoid-returning-widgets.md#config-example)

    Warns when a method or function returns a Widget or subclass of a Widget.

- [avoid-unnecessary-setstate](./flutter/avoid-unnecessary-setstate.md)

    Warns when `setState` is called inside `initState`, `didUpdateWidget` or `build` methods and when it is called from a `sync` method that is called inside those methods.

- [avoid-wrapping-in-padding](./flutter/avoid-wrapping-in-padding.md)

    Warns when a widget is wrapped in a Padding widget but has a padding settings by itself.

- [prefer-const-border-radius](./flutter/prefer-const-border-radius.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

    Warns when used non const border radius.

- [prefer-extracting-callbacks](./flutter/prefer-extracting-callbacks.md) &nbsp; [![Configurable](https://img.shields.io/badge/-configurable-informational)](./flutter/prefer-extracting-callbacks.md#config-example)

    Warns about inline callbacks in a widget tree and suggest to extract them to a widget method.

- [prefer-single-widget-per-file](./flutter/prefer-single-widget-per-file.md) &nbsp; [![Configurable](https://img.shields.io/badge/-configurable-informational)](./flutter/prefer-single-widget-per-file.md#config-example)

    Warns when a file contains more than a single widget.

## Intl specific {#intl-specific}

- [prefer-intl-name](./intl/prefer-intl-name.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

    Recommends to use ClassName_ClassMemberName pattern for Intl methods name argument.

- [provide-correct-intl-args](./intl/provide-correct-intl-args.md)

    Warns when the Intl.message() invocation has incorrect args.

## Angular specific {#angular-specific}

- [avoid-preserve-whitespace-false](./angular/avoid-preserve-whitespace-false.md)

    Warns when a `@Component` annotation has explicit false value for preserveWhitespace.

- [component-annotation-arguments-ordering](./angular/component-annotation-arguments-ordering.md) &nbsp; [![Configurable](https://img.shields.io/badge/-configurable-informational)](./angular/component-annotation-arguments-ordering.md#config-example)

    Enforces Angular `@Component` annotation arguments ordering.

- [prefer-on-push-cd-strategy](./angular/prefer-on-push-cd-strategy.md)

    Prefer setting changeDetection: ChangeDetectionStrategy.OnPush in Angular `@Component` annotations.
