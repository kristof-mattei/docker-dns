FROM alpine:3.18

RUN apk add --update --no-cache curl
RUN apk add --update --no-cache g++
# RUN apk add --update --no-cache libev
RUN apk add --update --no-cache libffi-dev
# RUN apk add --update --no-cache libstdc++
RUN apk add --update --no-cache python3
RUN apk add --update --no-cache python3-dev
RUN ln -sf python3 /usr/bin/python

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1
ENV \
    POETRY_VERSION=$POETRY_VERSION \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1

RUN curl --silent --show-error --location https://install.python-poetry.org | python3
ENV PATH="$POETRY_HOME/bin:$PATH"

WORKDIR /app

ADD poetry.lock ./
ADD pyproject.toml ./

RUN poetry install
RUN apk del curl g++ libffi-dev python3-dev && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

ADD dockerdns .

ENTRYPOINT ["poetry", "run", "python", "./dockerdns"]
