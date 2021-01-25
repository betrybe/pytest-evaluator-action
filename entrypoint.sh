#!/bin/sh -l
set -x

# Install deps and run pytest over the student source
cd /github/workspace
if test -f "dev-requirements.txt" ; then
  python3 -m pip install -r dev-requirements.txt
else
  python3 -m pip install -r requirements.txt
fi
python3 -m pytest --json=/tmp/report.json

# Run evaluator over pytest result assuring that the requirements file is the original
python3 /home/evaluation.py /tmp/report.json /github/workspace/.trybe/requirements.json > /tmp/evaluation_result.json

if [ $? != 0 ]; then
  printf "Execution error $?"
  exit 1
fi

echo ::set-output name=result::`cat /tmp/evaluation_result.json | base64 -w 0`
