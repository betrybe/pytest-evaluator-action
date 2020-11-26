#!/bin/sh -l
set -x

git clone --single-branch --branch "$INPUT_REPOSITORY_MAIN_BRANCH" "https://github.com/$GITHUB_REPOSITORY.git" /github/main-branch/
if [ $? != 0 ]; then
  printf "Execution error $?"
  exit 1
fi

# Assure that the tests are the originals
rm -rf /github/workspace/tests
cp -r /github/main-branch/tests /github/workspace

# Install deps and run pytest over the student source
cd /github/workspace
if test -f "dev-requirements.txt" ; then
  python3 -m pip install -r dev-requirements.txt
else
  python3 -m pip install -r requirements.txt
fi
python3 -m pytest --json=/tmp/report.json

# Run evaluator over pytest result assuring that the requirements file is the original
python3 /home/evaluation.py /tmp/report.json /github/main-branch/.trybe/requirements.json > /tmp/evaluation_result.json

if [ $? != 0 ]; then
  printf "Execution error $?"
  exit 1
fi

echo ::set-output name=result::`cat /tmp/evaluation_result.json | base64 -w 0`
