# Pytest Evaluator Action

This action run Pytest over project and build a evaluation `.json` as result

### Install dependencies

```sh
make install
# or
python3 -m pip install -r requirements.txt
```

### Run tests

```sh
make test
# or
python3 -m pytest
```

### Build docker image

```sh
make build
# or
docker build . -t 'pytest_evaluator_action'
```

## Evaluator Action

To call the evaluator action you must create `.github/workflows/main.yml` in the project repo with the release version.

```yml
on:
  workflow_dispatch:
    inputs:
      dispatch_token:
        description: 'Token that authorize the dispatch'
        required: true
      head_sha:
        description: 'Head commit SHA that dispatched the workflow'
        required: true
      pr_author_username:
        description: 'Pull Request author username'
        required: true
      pr_number:
        description: 'Pull Request number that dispatched the workflow'
        required: true

jobs:
  evaluator_job:
    name: Evaluator Job
    runs-on: ubuntu-18.04
    steps:
      - uses: actions/checkout@v2
      - name: Pytest Evaluator Step
        uses: betrybe/pytest-evaluator-action@v3
        with:
          pr_author_username: ${{ github.event.inputs.pr_author_username }}
        id: pytest_evaluator
      - name: Store evaluation step
        uses: betrybe/store-evaluation-action@v2
        with:
          evaluation-data: ${{ steps.pytest_evaluator.outputs.result }}
          environment: staging
          pr-number: ${{ github.event.inputs.pr_number }}

```

## Inputs

- `pr_author_username`

  **Required**

  Pull Request author username.

### Outputs

- `result`

  Evaluation result JSON in base64 format.

## Trybe requirements and expected results

In your project repository must create a file called `requirements.json` inside `.trybe` folder.

This file should have the following structure:

```json
{
  "requirements": [
    {
      "identifier": "test_desafio1",
      "description": "requirement #1",
      "bonus": false
    },
    {
      "identifier": "test_desafio2",
      "description": "requirement #2",
      "bonus": true
    },
    {
      "identifier": "test_desafio3",
      "description": "requirement #3",
      "bonus": false
    }
  ]
}
```

where:
- the `"requirement #1"`, `"requirement #2"` and `"requirement #3"` are the **requirements description**
- the `identifier` must be **exactly the same** as the **test function name** (e.g. `test_function_a`)

## Learn about GitHub Actions

- https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-a-docker-container-action
