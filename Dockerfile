FROM python:3.8-slim-buster

LABEL maintainer=evgen.kanashevsky@gmail.com

RUN apt-get update && apt-get upgrade -y && apt-get install -y git curl && apt-get clean -y

RUN mkdir -p /opt/audrey-hopburn
WORKDIR /opt/audrey-hopburn

RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
RUN pip install pip-tools

# Install and cache dependencies
COPY setup.cfg  /opt/audrey-hopburn/
COPY setup.py  /opt/audrey-hopburn/
COPY audrey-hopburn/__init__.py /opt/audrey-hopburn/audrey-hopburn/__init__.py
RUN pip-compile -o requirements.txt
RUN pip install -r requirements.txt

COPY . /opt/audrey-hopburn
RUN pip install .
ENV PYTHONHASHSEED=0

ENTRYPOINT [ "python", "main.py" ]
