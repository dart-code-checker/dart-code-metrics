---
sidebar_position: 0
---

# Introduction

Dart Code Metrics is a static analysis tool that helps you analyse and improve your code quality.

It collects analytical data on the code through calculating code metrics with configurable thresholds and provides additional rules for the Dart analyzer.

It can be launched via the command line, connected as a plugin to the Dart Analysis Server, or as a library. Launching via the command line allows you to easily integrate the tool into the CI/CD process, and you can get results in Сonsole, HTML, JSON, CodeClimate, or GitHub. Connecting the tool as a plugin to the Analysis Server allows you to receive real-time feedback directly from the IDE.

## Metrics {#metrics}

Metrics can help manage codebase for teams or individuals working on both big and small projects.

Big projects usually have their own history with contributions from different people and sometimes it's really hard to detect places in the codebase that need attention the most.

For small projects metrics can help avoid the stage when codebase becomes harder to maintain because they provide instant feedback on any PR and questionable solutions might not even be merged into the main branch.

## Rules {#rules}

Other ecosystems have useful rules like unused arguments check, class member ordering check, etc. They’re not available in the built-in Dart SDK linter, but they are very handy and thats why Dart Code Metrics provides them.

Stylistic rules aren’t the only important things to consider; Dart Code Metrics also provide rules, that highlight potential errors like `no-equal-then-else`, `no-equal-arguments`, and more.

The rules are partially based on a personal experience during code reviews and feedback / requests from the community, so if you have any ideas to share, please don't hesitate! Another part of the rules emerged during the process of studying other tools’ rules. (Shoutout to PVS-Studio, TSLint, and ESLint for inspiration!)
