FROM php:8.3-fpm

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

# Install Symfony-CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    &&  mv ${HOME}/.symfony5/bin/symfony /usr/local/bin/symfony

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set the working directory
WORKDIR /var/www/html
VOLUME /var/www/html

RUN useradd -m symfony

# Set entrypoint
COPY Docker/php/local-deploy.sh /usr/local/bin/local-deploy
RUN chmod +x /usr/local/bin/local-deploy
ENTRYPOINT ["local-deploy"]

CMD ["symfony", "server:start", "--no-tls", "--allow-all-ip"]