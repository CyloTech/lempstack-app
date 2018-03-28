FROM repo.cylo.io/alpine-lep

ENV MYSQL_ROOT_PASSWORD=mysqlr00t
ENV MYSQL_DATABASE=${MYSQL_DATABASE:-""}
ENV	MYSQL_USER=${MYSQL_USER:-""}
ENV MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

RUN apk --update add mariadb mariadb-client

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	autoconf \
	automake \
	file \
	g++ \
	gcc \
	make \
	php7-dev \
	re2c \
	samba-dev \
	zlib-dev && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
    php7-mysqli \
	curl \
	libxml2 \
	php7-apcu \
	php7-ctype \
	php7-curl \
	php7-dom \
	php7-exif \
	php7-ftp \
	php7-gd \
	php7-gmp \
	php7-iconv \
	php7-imap \
	php7-mbstring \
	php7-mcrypt \
	php7-pcntl \
	php7-pdo_mysql \
	php7-pdo_pgsql \
	php7-pdo_sqlite \
	php7-pgsql


RUN docker-php-ext-configure gd --with-freetype-dir=/usr --with-png-dir=/usr --with-jpeg-dir=/usr; \
        docker-php-ext-install \
            exif \
            gd \
            intl \
            mbstring \
            mysqli \
            opcache \
            pcntl \
            pdo_mysql


ADD scripts/entrypoint.sh /scripts/entrypoint.sh
ADD scripts/mariadb.sh /scripts/mariadb.sh
RUN chmod -R +x /scripts

ENTRYPOINT [ "/scripts/entrypoint.sh" ]
CMD [ "/start.sh" ]