FROM python:3.5-alpine

MAINTAINER Guy John "guy@rumblesan.com"

RUN mkdir -p /opt/flaskapp
WORKDIR /opt/flaskapp

RUN adduser -S flask
RUN chown flask /opt/flaskapp
USER flask

COPY requirements.txt .
RUN pip install --user -r requirements.txt

COPY config.py .
COPY app.py .

CMD ["python", "app.py"]
