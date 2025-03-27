FROM php:8.3-apache

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
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp

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
    && pecl install xdebug

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
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Enable Apache2 modules
RUN a2enmod rewrite expires headers

# Install Symfony-CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    &&  mv ${HOME}/.symfony5/bin/symfony /usr/local/bin/symfony

# Install Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Install NodeJS
COPY --from=node:lts-bookworm /usr/local/bin /usr/local/bin
COPY --from=node:lts-bookworm /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node:lts-bookworm /opt /opt

# Generate and enable SSL/TLS certificate
RUN set -eux; \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=FR/ST=France/L=Saint Maximin/O=Theta/OU=Theta Team Web/CN=devmaster.local"; \
	chmod 777 /etc/ssl/private; \
	chmod 777 /etc/ssl/private/ssl-cert-snakeoil.key; \
	a2enmod ssl; \
	a2ensite default-ssl

WORKDIR /var/www/html
VOLUME /var/www/html

RUN useradd -m devmaster

# Set entrypoint
COPY Docker/php/local-deploy.sh /usr/local/bin/local-deploy
RUN chmod +x /usr/local/bin/local-deploy
ENTRYPOINT ["local-deploy"]

CMD ["apache2-foreground"]