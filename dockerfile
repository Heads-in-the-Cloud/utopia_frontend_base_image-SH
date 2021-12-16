# For a reasoning on Debian slim pre-built Python image over using Alpine look here:
# https://pythonspeed.com/articles/alpine-docker-python/
#
# tl;dr:
#   Alpine's use of the musl instead of glibc makes for headaches trying to work with
#   python, especially some popular (and C-heavy) libraries.

FROM python:3.9-slim

RUN useradd utopian

WORKDIR /home/utopian

# Copying in and applying the project requirements to a virtualenv.
COPY ["requirements.txt", "requirements.txt"]
RUN python -m venv venv
RUN venv/bin/pip install --upgrade pip
RUN venv/bin/pip install -r requirements.txt

# GUnicorn is installed in its own, non-version-specific command to ensure the most up-to-date version since webserver
# security is always enhancing and adapting to threats. Also, Gunicorn is highly unlikely to ever introduce
# code-breaking changes since it will always adhere to the WSGI standards.
RUN venv/bin/pip install gunicorn
