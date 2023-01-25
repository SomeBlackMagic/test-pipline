ARG DOCKER_PHP_VERSION
FROM php:${DOCKER_PHP_VERSION}-fpm

###
### Upgrade (install ps)
###
RUN set -eux \
    && DEBIAN_FRONTEND=noninteractive apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
        procps \
        curl \
        apt-utils

# -------------------- Installing PHP Extension: mcrypt --------------------
RUN set -eux \
	# Installation: Version specific
	# Type:         PECL extension
	# Default:      Pecl command
	&& apt-get install -y libmcrypt-dev \
	&& pecl install mcrypt \
	# Enabling
	&& docker-php-ext-enable mcrypt \
	&& true

# -------------------- Installing PHP Extension: bcmath --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         Built-in extension
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) bcmath \
	&& true

# -------------------- Installing PHP Extension: sockets --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         Built-in extension
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) sockets \
	&& true


# -------------------- Installing PHP Extension: intl --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         Built-in extension
	&& apt-get install -y libicu-dev \
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) intl \
	&& true

# -------------------- Installing PHP Extension: opcache --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         Built-in extension
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) opcache \
	&& true

# -------------------- Installing PHP Extension: amqp --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         PECL extension
	# Custom:       Pecl command
	&& apt-get install -y librabbitmq-dev \
	&& echo "/usr" | pecl install amqp \
	# Enabling
	&& docker-php-ext-enable amqp \
	&& true

# -------------------- Installing PHP Extension: redis --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         PECL extension
	# Default:      Pecl command
	&& pecl install redis \
	# Enabling
	&& docker-php-ext-enable redis \
	&& true

# -------------------- Installing PHP Extension: zip --------------------
RUN set -eux \
	# Installation: Version specific
	# Type:         Built-in extension
	# Custom:       configure command
	&& apt-get install -y libzip-dev \
	&& docker-php-ext-configure zip --with-zip \
	# Installation
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) zip \
	&& true

# -------------------- Installing PHP Extension: pdo_mysql --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         Built-in extension
	# Custom:       configure command
	&& docker-php-ext-configure pdo_mysql --with-zlib-dir=/usr \
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pdo_mysql \
	&& true

# -------------------- Installing PHP Extension: pcntl --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         Built-in extension
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pcntl \
	&& true

# -------------------- Installing PHP Extension: mbstring --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         Built-in extension
	&& apt-get install -y libonig-dev \
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mbstring \
	&& true

# -------------------- Installing PHP Extension: json --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         Built-in extension
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) json \
	&& true

# -------------------- Installing PHP Extension: imagic --------------------
RUN set -eux \
	# Installation: Version specific
	# Type:         PECL extension
	# Default:      Pecl command
	&& apt-get install -y libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
	# Enabling
	&& docker-php-ext-enable imagick \
	&& true

# -------------------- Delete extracted php source --------------------
RUN set -eux \
    && docker-php-source delete \
    && true

# Enable php fpm status page
RUN set -xe && echo "pm.status_path = /status" >> /usr/local/etc/php-fpm.d/zz-docker.conf

RUN set -eux \
    && curl https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck > /usr/local/bin/php-fpm-healthcheck \
    && chmod +x /usr/local/bin/php-fpm-healthcheck \
    && apt install -y libfcgi-bin \
    && true

###
### Envs
###
ENV MY_USER="app" \
    MY_GROUP="app"

ARG DOCKER_UID=1000
ARG DOCKER_GID=1000

###
### User/Group
###
RUN set -eux \
	&& groupadd -g ${DOCKER_GID} -r ${MY_GROUP} \
	&& useradd -d /home/${MY_USER} -u ${DOCKER_UID} -m -s /bin/bash -g ${MY_GROUP} ${MY_USER}


###
### Copy files
###
###
COPY ./data/php.ini /usr/local/etc/php/conf.d/default-php.ini
COPY ./data/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./data/global.conf /usr/local/etc/php-fpm.d/global.conf

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./data/docker-entrypoint.d /docker-entrypoint.d

RUN chmod +x /docker-entrypoint.sh


###
### Verify
###
RUN set -eux \
    && echo "date.timezone=UTC" > /usr/local/etc/php/php.ini \
    && php -v | grep -oE 'PHP\s[.0-9]+' | grep -oE '[.0-9]+' | grep '^7.4' \
    && /usr/local/sbin/php-fpm --test \
    \
    && PHP_ERROR="$( php -v 2>&1 1>/dev/null )" \
    && if [ -n "${PHP_ERROR}" ]; then echo "${PHP_ERROR}"; false; fi \
    && PHP_ERROR="$( php -i 2>&1 1>/dev/null )" \
    && if [ -n "${PHP_ERROR}" ]; then echo "${PHP_ERROR}"; false; fi \
    \
    && PHP_FPM_ERROR="$( php-fpm -v 2>&1 1>/dev/null )" \
    && if [ -n "${PHP_FPM_ERROR}" ]; then echo "${PHP_FPM_ERROR}"; false; fi \
    && PHP_FPM_ERROR="$( php-fpm -i 2>&1 1>/dev/null )" \
    && if [ -n "${PHP_FPM_ERROR}" ]; then echo "${PHP_FPM_ERROR}"; false; fi \
    && rm -f /usr/local/etc/php/php.ini

###
### Entrypoint
###
CMD ["/usr/local/sbin/php-fpm"]
ENTRYPOINT ["/docker-entrypoint.sh"]
