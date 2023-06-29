## composer
FROM composer:2.4.1 AS composer-cache
WORKDIR /code
# copy only composer files for caching
COPY composer.json composer.lock /code/

## appliation
FROM php:8.2-fpm

COPY --from=composer-cache /usr/bin/composer /usr/bin/composer

WORKDIR /code

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
    g++ \
    locales \
    unzip \
    zip \
    libicu-dev \
    libmemcached-dev \
    libzip-dev \
    zlib1g-dev \
    libonig-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /music

RUN docker-php-ext-configure gd --with-jpeg=/usr/include/ && \
    docker-php-ext-install -j$(nproc) bcmath \
    intl \
    pdo_mysql \
    opcache \
    bcmath \
    gd \
    exif \
    zip && \
    rm -rf /tmp/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

ENV FFMPEG_PATH=/usr/bin/ffmpeg \
    MEDIA_PATH=/music \
    LANG=ja_JP.UTF-8 \
    LANGUAGE=ja_JP:ja \
    LC_ALL=ja_JP.UTF-8
