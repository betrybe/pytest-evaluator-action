#!/bin/bash

export DB_HOST=localhost

sudo apt update
sudo add-apt-repository -y ppa:deadsnakes/ppa
echo "INSTALANDO PYTHON"
sudo apt install -y "python$INPUT_PYTHON_VERSION"
echo "INSTALANDO PYTHON-DISUTILS"
sudo apt install -y "python$INPUT_PYTHON_VERSION-distutils"
echo "INSTALANDO PIP"
curl -sS https://bootstrap.pypa.io/get-pip.py | sudo "python$INPUT_PYTHON_VERSION"


"python$INPUT_PYTHON_VERSION" -m pip install virtualenv wheel --no-cache-dir

# Install deps and run pytest over the student source
"python$INPUT_PYTHON_VERSION" -m venv ".venv/$INPUT_PR_AUTHOR_USERNAME-project" --system-site-packages
source ".venv/$INPUT_PR_AUTHOR_USERNAME-project/bin/activate"
if test -f "dev-requirements.txt" ; then
  "python$INPUT_PYTHON_VERSION" -m pip install -r dev-requirements.txt --no-cache-dir
else
  "python$INPUT_PYTHON_VERSION" -m pip install -r requirements.txt --no-cache-dir
fi
"python$INPUT_PYTHON_VERSION" -m pytest --json=/tmp/report.json

"python$INPUT_PYTHON_VERSION" -m venv ".venv/$INPUT_PR_AUTHOR_USERNAME-evaluator" --system-site-packages
source ".venv/$INPUT_PR_AUTHOR_USERNAME-evaluator/bin/activate"
"python$INPUT_PYTHON_VERSION" -m pip install -r "$EVALUATOR_REQUIREMENTS"
"python$INPUT_PYTHON_VERSION" "$EVALUATOR_SRC/evaluation.py" /tmp/report.json .trybe/requirements.json > /tmp/evaluation_result.json

if [ $? != 0 ]; then
  printf "Execution error $?"
  exit 1
fi

echo `cat /tmp/evaluation_result.json | base64 -w 0`
echo ::set-output name=result::`cat /tmp/evaluation_result.json | base64 -w 0`
