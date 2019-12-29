FROM python:2.7-alpine

ADD eyefiserver.py /usr/local/bin/
RUN mkdir /uploads

VOLUME /uploads
EXPOSE 59278
ENTRYPOINT [ "python", "/usr/local/bin/eyefiserver.py" ]