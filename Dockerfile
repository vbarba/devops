FROM python:3.6-alpine

RUN adduser -D devops

WORKDIR /home/devops

COPY requirements.txt requirements.txt
RUN apk update && apk add --no-cache mariadb-dev build-base
RUN python -m venv venv
RUN venv/bin/pip install --upgrade pip
RUN venv/bin/pip install -r requirements.txt
RUN venv/bin/pip install gunicorn
RUN venv/bin/pip install mysqlclient

COPY app app
COPY migrations migrations
COPY devops.py config.py boot.sh test_app.py ./

# run unit tests
RUN venv/bin/python test_app.py

RUN chmod a+x boot.sh

ENV FLASK_APP devops.py

RUN chown -R devops:devops ./
USER devops

EXPOSE 5000
ENTRYPOINT ["./boot.sh"]
