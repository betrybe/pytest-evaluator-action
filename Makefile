install:
	python3 -m pip install -r requirements.txt

test:
	python3 -m flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
	python3 -m flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
	GITHUB_ACTOR=tryber GITHUB_REPOSITORY=betrybe/pytest-evaluator-action python3 -m pytest -s

build:
	docker build . -t 'pytest_evaluator_action'
