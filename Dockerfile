FROM python:3.6-alpine

WORKDIR /usr/src

COPY ./requirements.txt /usr/src/
RUN pip3 install -r ./requirements.txt

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONNUNBUFFERED 1

COPY showoff /usr/src/app

EXPOSE 5000
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]

