#!/bin/bash

export DB_HOST=localhost

python -m pip install virtualenv wheel --no-cache-dir

# Install deps and run pytest over the student source
python -m venv ".venv/$INPUT_PR_AUTHOR_USERNAME-project" --system-site-packages
source ".venv/$INPUT_PR_AUTHOR_USERNAME-project/bin/activate"
if test -f "dev-requirements.txt" ; then
  python -m pip install -r dev-requirements.txt --no-cache-dir
else
  python -m pip install -r requirements.txt --no-cache-dir
fi
python -m pytest --json=/tmp/report.json

python -m venv ".venv/$INPUT_PR_AUTHOR_USERNAME-evaluator" --system-site-packages
source ".venv/$INPUT_PR_AUTHOR_USERNAME-evaluator/bin/activate"
python -m pip install -r "$EVALUATOR_REQUIREMENTS"
python "$EVALUATOR_SRC/evaluation.py" /tmp/report.json .trybe/requirements.json > /tmp/evaluation_result.json

if [ $? != 0 ]; then
  printf "Execution error $?"
  exit 1
fi

echo `cat /tmp/evaluation_result.json | base64 -w 0`
# echo ::set-output name=result::`cat /tmp/evaluation_result.json | base64 -w 0`

echo name=result >> $GITHUB_OUTPUT `cat /tmp/evaluation_result.json | base64 -w 0`
