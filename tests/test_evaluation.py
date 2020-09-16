from src.evaluation import *

CURRENT_PATH = os.path.dirname(__file__)
FAILED_GRADE = 0
PASSED_GRADE = 3

def test_generate_result_success():
    report_file = os.path.join(CURRENT_PATH, 'fixture', 'report.json')
    req_file = os.path.join(CURRENT_PATH, 'fixture', 'requirements.json')
    reqs = load_file(req_file)
    reqs = list(reqs['requirements'])

    res = generate_result(report_file, req_file)

    assert 'evaluations' in res
    tests_eval = list(res['evaluations'])
    assert len(tests_eval) == len(reqs)
    assert tests_eval[0]['grade'] == PASSED_GRADE
    assert tests_eval[0]['identifier'] == reqs[0]['identifier']
    assert tests_eval[0]['description'] == reqs[0]['description']
    assert tests_eval[1]['grade'] == FAILED_GRADE
    assert tests_eval[1]['identifier'] == reqs[1]['identifier']
    assert tests_eval[1]['description'] == reqs[1]['description']


def load_file(file):
    with open(file, 'r') as read_file:
        r = json.load(read_file)

    return r