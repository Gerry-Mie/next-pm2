# Start with the official PHP 8.1 FPM image based on Alpine
FROM php:8.2-alpine

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apk update && apk add --no-cache \
    build-base \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    oniguruma-dev \
    libxml2-dev \
    libzip-dev \
    libmcrypt-dev \
    fcgi \
    # Install Node.js and npm
    && curl -fsSL https://unofficial-builds.nodejs.org/download/release/v16.3.0/node-v16.3.0-linux-x64.tar.xz | tar -xJ -C /usr/local --strip-components=1 \
    # Install PHP extensions
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer
COPY --from=composer:2.5 /usr/bin/composer /usr/bin/composer

# Copy existing application directory contents
COPY . /app

# Copy existing application directory permissions
COPY --chown=www-data:www-data . /app

# Install npm packages
RUN npm install

# Install Composer dependencies
RUN composer install

# Expose port 3102
EXPOSE 3102

# Change current user to www
USER www-data

# Start PHP-FPM server
CMD ["php", "artisan", "serve", "--port=3102"]
