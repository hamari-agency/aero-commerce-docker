FROM php:7.4-fpm

RUN echo uname -v

ADD ./php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN addgroup -gid 1000 aero && useradd -G aero -g aero -u 1000 -d /bin/sh aero

RUN mkdir -p /var/www/html

RUN chown aero:aero /var/www/html

WORKDIR /var/www/html

RUN apt-get update -y

# all bar send mail and libzip required for gd
RUN apt-get install -y --no-install-recommends \
sendmail \
libzip-dev \
zlib1g-dev \
libpng-dev \
libjpeg-dev \
libfreetype6-dev \
libwebp-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-install pdo pdo_mysql zip gd bcmath
RUN pecl install redis && docker-php-ext-enable redis

# Aero requires node for ssr

RUN curl -o /usr/local/bin/node.tar.xz https://nodejs.org/dist/v14.16.1/node-v14.16.1-linux-x64.tar.xz

RUN tar -xf /usr/local/bin/node.tar.xz -C /usr/local/bin

RUN mv /usr/local/bin/node-v14.16.1-linux-x64/bin/node /usr/local/bin

RUN rm /usr/local/bin/node.tar.xz && rm -rf /usr/local/bin/node-v14.16.1-linux-x64/

ENV PATH="/usr/local/bin:${PATH}"

RUN node --version

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"