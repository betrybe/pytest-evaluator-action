FROM python:3.9.0-buster

RUN apt update && \
    apt -yq install apt-utils git less

COPY entrypoint.sh /home/entrypoint.sh
COPY src/evaluation.py /home/evaluation.py

RUN chmod a+x -R /home/entrypoint.sh /home/evaluation.py

ENTRYPOINT ["/home/entrypoint.sh"]
