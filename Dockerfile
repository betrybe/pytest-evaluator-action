FROM alpine:3.12.0

RUN apk --update add python3 && \
    apk add py3-pip && \
    apk add coreutils && \
    apk add git less openssh && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

COPY entrypoint.sh /home/entrypoint.sh
COPY src/evaluation.py /home/evaluation.py

RUN chmod a+x -R /home/entrypoint.sh /home/evaluation.py

ENTRYPOINT ["/home/entrypoint.sh"]
