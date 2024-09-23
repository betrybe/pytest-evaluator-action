#!/bin/bash

export DB_HOST=localhost

# instala o virtualenv para ter ambientes isolados
python -m pip install virtualenv wheel --no-cache-dir

# cria e ativa um ambiente virtual para o projeto da pessoa estudante
python -m venv ".venv/$INPUT_PR_AUTHOR_USERNAME-project" --system-site-packages
source ".venv/$INPUT_PR_AUTHOR_USERNAME-project/bin/activate"

# instala as dependências do projeto da pessoa estudante
if test -f "test-requirements.txt" ; then
  python -m pip install -r test-requirements.txt --no-cache-dir
elif test -f "dev-requirements.txt" ; then
  python -m pip install -r dev-requirements.txt --no-cache-dir
else
  python -m pip install -r requirements.txt --no-cache-dir
fi

# executa os testes do projeto da pessoa estudante e salva o resultado em um arquivo json
python -m pytest --json=/tmp/report.json


# cria e ativa um ambiente virtual para o avaliador
python -m venv ".venv/$INPUT_PR_AUTHOR_USERNAME-evaluator" --system-site-packages
source ".venv/$INPUT_PR_AUTHOR_USERNAME-evaluator/bin/activate"

# instala as dependências do avaliador
python -m pip install -r "$EVALUATOR_REQUIREMENTS"

# executa a lógica do avaliador em cima do resultado dos testes, e salva o resultado em um arquivo json
python "$EVALUATOR_SRC/evaluation.py" /tmp/report.json .trybe/requirements.json > /tmp/evaluation_result.json

if [ $? != 0 ]; then
  printf "Execution error $?"
  exit 1
fi

# imprime e salva a saída do avaliador em base64
echo `cat /tmp/evaluation_result.json | base64 -w 0`
echo "result=`cat /tmp/evaluation_result.json | base64 -w 0`" >> $GITHUB_OUTPUT
