# Long Method

Long blocks of code are difficult to reuse and understand because they are usually responsible for more than one thing. Separating those to several short ones with proper names helps you reuse your code and understand it better without reading methods body.

Lines of code with clarification comments are usually a sign for possible method extraction because you can name extracted method in a way that will cover the comment description and then remove the comment. Even comments for one line is a sign for method extraction.

* To shorten a method, just apply **Extract Method** command.
* If local variables and parameters prevent a method extraction, apply **Replace Temp with Query**, **Introduce Parameter Object** or **Preserve Whole Object** commands.
* Conditional statements or loops indicate the possibility of method extraction. Use **Decompose Conditional** command for conditional expressions and **Extract Method** for loops.

## Detection strategy

Uses [`Source lines of Code`](../metrics/source-lines-of-code.md) value and compares it with configured threshold.

## Exceptions

* Flutter widget build method.

---

P.S. We use terminology from a book **Refactoring Improving the Design of Existing Code** by *Martin Fowler*
