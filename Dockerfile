FROM python:2.7-alpine

ADD eyefiserver.py .
RUN mkdir uploads

VOLUME /uploads
EXPOSE 59278
ENTRYPOINT [ "python", "eyefiserver.py" ]