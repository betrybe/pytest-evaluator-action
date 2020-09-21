import os
import json
from src import evaluation

CURRENT_PATH = os.path.dirname(__file__)


def test_generate_result_success():
    fake_report = os.path.join(CURRENT_PATH, 'fixture', 'report.json')

    req_mock = os.path.join(CURRENT_PATH, 'fixture', 'requirements.json')
    reqs = load_file(req_mock)
    requirements = list(reqs['requirements'])

    result = evaluation.generate_result(fake_report, req_mock)

    assert 'evaluations' in result
    evaluations = list(result['evaluations'])
    assert len(evaluations) == len(requirements)
    # If test passed, should return passed grade
    assert evaluations[0]['grade'] == evaluation.PASSED_GRADE
    assert evaluations[0]['description'] == requirements[0]['description']
    # If test failed, should return failed grade
    assert evaluations[1]['grade'] == evaluation.FAILED_GRADE
    assert evaluations[1]['description'] == requirements[1]['description']
    # If test is not found on report, should return failed grade
    assert evaluations[2]['grade'] == evaluation.FAILED_GRADE
    assert evaluations[2]['description'] == requirements[2]['description']


def test_enums():
    evaluation.FAILED_GRADE == 1
    evaluation.PASSED_GRADE == 3


def load_file(file):
    with open(file, 'r') as read_file:
        r = json.load(read_file)

    return r
