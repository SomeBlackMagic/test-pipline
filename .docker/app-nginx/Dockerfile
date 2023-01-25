ARG DOCKER_IMAGE_VERSION=master
ARG DOCKER_SERVER_HOST
ARG DOCKER_PROJECT_PATH
ARG DOCKER_PHP_VERSION
ARG APP_ENV=prod

FROM ${DOCKER_SERVER_HOST}/${DOCKER_PROJECT_PATH}/app-${APP_ENV}:${DOCKER_IMAGE_VERSION} AS app
FROM nginx

WORKDIR /app

COPY .docker/app-nginx/conf/project.conf /etc/nginx/conf.d/default.conf

COPY --from=app /app/public /app/public

STOPSIGNAL SIGTERM

