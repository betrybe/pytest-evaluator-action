import os
import json
from src.evaluation import generate_result

CURRENT_PATH = os.path.dirname(__file__)
FAILED_GRADE = 0
PASSED_GRADE = 3

def test_generate_result_success():
    fake_report = os.path.join(CURRENT_PATH, 'fixture', 'report.json')

    req_mock = os.path.join(CURRENT_PATH, 'fixture', 'requirements.json')
    reqs = load_file(req_mock)
    reqs = list(reqs['requirements'])

    res = generate_result(fake_report, req_mock)

    assert 'evaluations' in res
    tests_eval = list(res['evaluations'])
    assert len(tests_eval) == len(reqs)
    # If test passed, should return passed grade
    assert tests_eval[0]['grade'] == PASSED_GRADE
    assert tests_eval[0]['description'] == reqs[0]['description']
    # If test failed, should return failed grade
    assert tests_eval[1]['grade'] == FAILED_GRADE
    assert tests_eval[1]['description'] == reqs[1]['description']
    # If test is not found on report, should return failed grade
    assert tests_eval[2]['grade'] == FAILED_GRADE
    assert tests_eval[2]['description'] == reqs[2]['description']


def load_file(file):
    with open(file, 'r') as read_file:
        r = json.load(read_file)

    return r
