import os
import json
import sys

FAILED_GRADE = 0
PASSED_GRADE = 3

def generate_result(report_file, req_file):
    with open(report_file, 'r') as read_file:
        report = json.load(read_file)
    tests = list(report['report']['tests'])

    with open(req_file, 'r') as read_file:
        r = json.load(read_file)
    reqs = list(r['requirements'])

    evaluations = []
    for req in reqs:
        evaluation = {
            "description": req['description'],
            "grade": FAILED_GRADE
        }

        test_result = list(filter(
            lambda test: req['identifier'] in test['name'],
            tests
        ))
        if len(test_result) == 0:
            evaluations.append(evaluation)
            continue

        test_result = next(iter(test_result))
        if test_result['outcome'] == 'passed':
            evaluation['grade'] = PASSED_GRADE
        evaluations.append(evaluation)

    return {
        'github_username': os.getenv('GITHUB_ACTOR', ''),
        'github_repository_name': os.getenv('GITHUB_REPOSITORY', ''),
        'evaluations': evaluations
    }

if __name__ == "__main__":
    if len(sys.argv) < 3:
        raise ValueError("You must pass report and requirements files as argument!")

    result = generate_result(sys.argv[1], sys.argv[2])
    print(json.dumps(result, sort_keys=True, indent=4))
