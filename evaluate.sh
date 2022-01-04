#!/bin/sh -l

# Install deps and run pytest over the student source
if test -f "dev-requirements.txt" ; then
  python3 -m pip install -r dev-requirements.txt
else
  python3 -m pip install -r requirements.txt
fi
python3 -m pytest --json=/tmp/report.json
