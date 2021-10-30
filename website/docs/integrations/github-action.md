# GitHub Action

Dart Code Metrics GitHub Action allows you to integrate Dart Code Metrics into your CI/CD process and get code quality reports inside PR's.

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
      - uses: actions/checkout@v2

      - name: dart-code-metrics
        uses: dart-code-checker/dart-code-metrics-action@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Inputs {#inputs}

| Name                   | Required                                                                  | Description                                                                                                                                                                                                                                                                                                         | Default |
| :--------------------- | :------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------ |
| **github_token**       | ☑️                                                                         | Required to post a report on GitHub. _Note:_ the secret [`GITHUB_TOKEN`](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/authenticating-with-the-github_token) is already provided by GitHub and you don't have to set it up yourself.                                              |         |
| **folders**            |                                                                           | List of folders whose contents will be scanned.                                                                                                                                                                                                                                                                     | [`lib`] |
| **relative_path**      |                                                                           | If your package isn't at the root of the repository, set this input to indicate its location.                                                                                                                                                                                                                       |         |
| **github_pat**         | Required if you had private GitHub repository in the package dependencies | [**Personal access token**](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) must access to _repo_ and _read:user_ [scopes](https://docs.github.com/en/developers/apps/building-oauth-apps/scopes-for-oauth-apps#available-scopes) |         |
| **check_unused_files** |                                                                           | Additional scan for find unused files in package.                                                                                                                                                                                                                                                                   | `false` |

### Output example {#output-example}

#### Analysis result {#analysis-result}

![Analysis result example](../../static/img/action-analysis-result.png)

#### Annotation {#annotation}

![Annotation example](../../static/img/annotation.png)
