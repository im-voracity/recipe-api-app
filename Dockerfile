FROM python:3.9-alpine3.13
LABEL maintainer="Matheus Tenório"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
      then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
    djangouser && \
    chown -R djangouser:djangouser /app && chmod -R 755 /app

ENV PATH="/py/bin:$PATH"

USER djangouser

# If facing the error "PermissionError: [Errno 13] Permission denied: '/app/manage.py"
# Run the following command to fix the permissions
# docker compose run --rm app sh -c "chown djangouser:djangouser -R /app/"
