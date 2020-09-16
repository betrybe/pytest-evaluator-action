install:
	python3 -m pip install -r requirements.txt

test:
	GITHUB_ACTOR=tryber GITHUB_REPOSITORY=betrybe/pytest-evaluator-action python3 -m pytest -s

build:
	docker build . -t 'pytest_evaluator_action'
