# Pytest Evaluator Action

Essa action executa o avaliador Pytest em projetos e exercícios da Trybe.

### Instalação de dependências

```sh
make install
# or
python3 -m pip install -r requirements.txt
```

### Testes

```sh
make test
# or
python3 -m pytest
```

## Evaluator Action

Para executar a action é preciso criar ou editar o arquivo `.github/workflows/main.yml` no repositório do exercício/projeto, e incluir as etapas `Fetch PyTest evaluator`, `Set Python Version` e `Run PyTest evaluation`, como exemplificado abaixo:

```yml
on:
  pull_request:
    types: [opened, synchronize]

jobs:
  evaluator:
    timeout-minutes: 20
    runs-on: self-hosted
    steps:
      ...

      - name: Fetch PyTest evaluator
        uses: actions/checkout@v3
        with:
          repository: betrybe/pytest-evaluator-action
          ref: v6.0
          token: ${{ secrets.GIT_HUB_PAT }}
          path: .github/actions/pytest-evaluator

      - name: Set Python Version
        uses: actions/setup-python@v4
        with:
          python-version: "3.10.6"

      - name: Run PyTest evaluation
        id: evaluator
        uses: ./.github/actions/pytest-evaluator
        with:
          pr_author_username: ${{ github.event.pull_request.user.login }}

      - name: Run Store evaluation
        uses: ./.github/actions/store-evaluation
        with:
          evaluation-data: ${{ steps.evaluator.outputs.result }}
          environment: production
          token: ${{ secrets.GITHUB_TOKEN }}
```

## Inputs

- `pr_author_username` (**obrigatório**)
  
  O GitHub username do autor do Pull Request.

### Outputs

- `result`
  
  O resultado da avaliação em JSON codificado em base64.
