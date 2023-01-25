ARG DOCKER_IMAGE_VERSION=master
ARG DOCKER_SERVER_HOST
ARG DOCKER_PROJECT_PATH
ARG DOCKER_PHP_VERSION
ARG APP_ENV=prod

FROM ${DOCKER_SERVER_HOST}/${DOCKER_PROJECT_PATH}/app-${APP_ENV}:${DOCKER_IMAGE_VERSION} AS app
FROM ${DOCKER_SERVER_HOST}/${DOCKER_PROJECT_PATH}/php${DOCKER_PHP_VERSION}-fpm:${DOCKER_IMAGE_VERSION}

COPY --from=app --chown=app:app /docker-entrypoint.d /docker-entrypoint.d
COPY --from=app --chown=app:app /app /app

ARG APP_ENV
ENV APP_ENV=${APP_ENV}

WORKDIR /app

RUN mkdir /init.d
COPY .docker/app-php/migrate.sh /init.d/migrate.sh
RUN chmod +x /init.d/migrate.sh
