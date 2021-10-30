# Long Parameter List

Long parameter lists are difficult to understand and use. Wrapping them into an object allows grouping parameters and change transferred data only by the object modification. When you're working with objects, you should pass just enough so that the method can get the data it needs.

* Use **Replace Parameter with Method** when you can obtain data by calling a method of an object.
* **Preserve Whole Object** allows you to take a group of arguments and replace them with the object.
* Use **Introduce Parameter Object**, if you have several arguments without logically grouping object.

***

P.S. We use terminology from a book **Refactoring Improving the Design of Existing Code** by *Martin Fowler*
