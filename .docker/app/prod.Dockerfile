# syntax=docker/dockerfile:experimental
ARG DOCKER_SERVER_HOST
ARG DOCKER_PROJECT_PATH
ARG DOCKER_PHP_VERSION
ARG DOCKER_IMAGE_VERSION=master

FROM ${DOCKER_SERVER_HOST}/${DOCKER_PROJECT_PATH}/php${DOCKER_PHP_VERSION}-composer:${DOCKER_IMAGE_VERSION} AS composer

WORKDIR /app
COPY composer.json /app/composer.json
COPY composer.lock /app/composer.lock
COPY symfony.lock /app/symfony.lock

RUN --mount=type=cache,sharing=shared,id=composer_cache,target=/.composer_cache composer install --no-dev --optimize-autoloader

COPY . /app

RUN rm -rf /app/tests
RUN rm -rf /app/.docker

RUN mkdir -p /app/var/cache && chmod 0750 /app/var/cache && chown 1000:1000 /app/var/cache
RUN mkdir -p /app/var/log && chmod 0750 /app/var/log && chown 1000:1000 /app/var/log

RUN APP_ENV=prod /app/bin/console -vvv cache:warmup
