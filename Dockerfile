# Start with the official PHP 8.2 FPM image based on Alpine
FROM php:8.2-alpine

# Set working directory
WORKDIR /app

# Update and Install system dependencies
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
    fcgi

# Install Node.js and npm using a trusted source
RUN apk add --no-cache nodejs npm

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
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

# Start PHP server with artisan
CMD ["php", "artisan", "serve", "--port=3102"]
