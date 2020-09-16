#!/bin/sh -l

git clone https://github.com/$GITHUB_REPOSITORY.git /github/master-repo/
rm -rf /github/workspace/tests
cp -r /github/master-repo/tests /github/workspace

cd /github/workspace
python3 -m pytest --json=/tmp/report.json

python3 /home/evaluation.py /tmp/report.json /github/master-repo/.trybe/requirements.json > /tmp/evaluation_result.json
echo "$(cat /tmp/evaluation_result.json)"

if [ $? != 0 ]; then
  printf "Execution error $?"
  exit 1
fi

echo ::set-output name=result::`cat /tmp/evaluation_result.json | base64 -w 0`
echo ::set-output name=pr-number::$(echo "$GITHUB_REF" | awk -F / '{print $3}')
