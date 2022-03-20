# GitHub Action

[Dart Code Metrics GitHub Action](https://github.com/marketplace/actions/dart-code-metrics-action) allows you to integrate Dart Code Metrics into your CI/CD process and get code quality reports inside PR's.

## Usage {#usage}

Create `dartcodemetrics.yaml` under `.github/workflows` with the following content (the default configuration listed):

```yml title="dartcodemetrics.yaml"
name: Dart Code Metrics

on: [push]

jobs:
  check:
    name: dart-code-metrics-action

    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: dart-code-metrics
        uses: dart-code-checker/dart-code-metrics-action@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Inputs {#inputs}

### Inputs

| Name                                  | Required                                                                  | Description                                                                                                                                                                                                                                                                                                         | Default                                                 |
| :------------------------------------ | :------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------------------------------------------------------ |
| **github_token**                      | ☑️                                                                         | Required to post a report on GitHub. *Note:* the secret [`GITHUB_TOKEN`](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/authenticating-with-the-github_token) is already provided by GitHub and you don't have to set it up yourself.                                              |                                                         |
| **github_pat**                        | Required if you had private GitHub repository in the package dependencies | [**Personal access token**](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) must access to *repo* and *read:user* [scopes](https://docs.github.com/en/developers/apps/building-oauth-apps/scopes-for-oauth-apps#available-scopes) |                                                         |
| **folders**                           |                                                                           | List of folders whose contents will be scanned.                                                                                                                                                                                                                                                                     | [`lib`]                                                 |
| **relative_path**                     |                                                                           | If your package isn't at the root of the repository, set this input to indicate its location.                                                                                                                                                                                                                       |                                                         |
| **pull_request_comment**              |                                                                           | Publish detailed report commented directly into your pull request.                                                                                                                                                                                                                                                  | `false`                                                 |
| **analyze_report_title_pattern**      |                                                                           | Configurable analyze report title pattern.                                                                                                                                                                                                                                                                          | `Dart Code Metrics analyze report of $packageName`      |
| **fatal_warnings**                    |                                                                           | Treat warning level issues as fatal.                                                                                                                                                                                                                                                                                | `false`                                                 |
| **fatal_performance**                 |                                                                           | Treat performance level issues as fatal.                                                                                                                                                                                                                                                                            | `false`                                                 |
| **fatal_style**                       |                                                                           | Treat style level issues as fatal.                                                                                                                                                                                                                                                                                  | `false`                                                 |
| **check_unused_files**                |                                                                           | Additional scan for find unused files in package.                                                                                                                                                                                                                                                                   | `false`                                                 |
| **check_unused_files_folders**        |                                                                           | List of folders whose contents will be scanned for find unused files.                                                                                                                                                                                                                                               | Taken from `folders` argument                           |
| **unused_files_report_title_pattern** |                                                                           | Configurable unused files report title pattern.                                                                                                                                                                                                                                                                     | `Dart Code Metrics unused files report of $packageName` |

### Output example {#output-example}

#### Analysis result {#analysis-result}

![Analysis result example](../../static/img/action-analysis-result.png)

#### Annotation {#annotation}

![Annotation example](../../static/img/annotation.png)
