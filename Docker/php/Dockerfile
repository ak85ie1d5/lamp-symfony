FROM php:7.3.33-apache

# Install packages from Aptitude
RUN apt-get update && apt-get install -y --no-install-recommends \
    ghostscript \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    libmagickwand-dev \
    libpng-dev \
    libwebp-dev \
    libzip-dev \
    unzip \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Configure libraries with Docker PHP extention package
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-webp-dir=/usr/include/

# Install libraries with Docker PHP extention package
RUN docker-php-ext-install -j$(nproc) \
    pcntl \
    bcmath \
    exif \
    gd \
    intl \
    mysqli \
    pdo_mysql \
    zip

# Install packages from PECL
RUN pecl install imagick \
    && pecl install xdebug-3.1.0

# Enabled libraries with Docker PHP extention package
RUN docker-php-ext-enable xdebug \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable bcmath \
    && docker-php-ext-enable exif \
    && docker-php-ext-enable gd \
    && docker-php-ext-enable intl \
    && docker-php-ext-enable mysqli \
    && docker-php-ext-enable pdo_mysql \
    && docker-php-ext-enable zip \
    && docker-php-ext-enable opcache

# change default Apache2 document root
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Enable Apache2 modules
RUN a2enmod rewrite expires headers

# Install Symfony-CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    &&  mv ${HOME}/.symfony5/bin/symfony /usr/local/bin/symfony

# Install Composer
COPY --from=composer:1.9.3 /usr/bin/composer /usr/bin/composer

# Add and enable SSL/TLS certificate
COPY Docker/php/cert/businessprofilers.pem /root/ssl-cert-snakeoil.pem
RUN set -eux; \
    openssl pkey -in /root/ssl-cert-snakeoil.pem -out /etc/ssl/private/ssl-cert-snakeoil.key; \
    openssl x509 -in /root/ssl-cert-snakeoil.pem -out /etc/ssl/certs/ssl-cert-snakeoil.pem
RUN set -eux; \
	chmod 777 /etc/ssl/private; \
	chmod 777 /etc/ssl/private/ssl-cert-snakeoil.key; \
    chmod 644 /etc/ssl/certs/ssl-cert-snakeoil.pem; \
    a2enmod ssl; \
    a2ensite default-ssl

WORKDIR /var/www/html
VOLUME /var/www/html

RUN useradd -m devmaster

CMD ["apache2-foreground"]
