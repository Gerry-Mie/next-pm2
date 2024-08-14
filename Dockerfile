# Start with the official PHP 8.1 FPM image
FROM php:8.2-alpine

# Set working directory
#WORKDIR /var/www/html
WORKDIR /app
# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libmcrypt-dev \
    libfcgi-bin \
    # Install Node.js and npm
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    # Install PHP extensions
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer
COPY --from=composer:2.5 /usr/bin/composer /usr/bin/composer

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy existing application directory contents
#COPY . /var/www/html
COPY . /app

# Copy existing application directory permissions
#COPY --chown=www-data:www-data . /var/www/html
COPY --chown=www-data:www-data . /app
# Install npm packages
RUN npm install

RUN composer install

# Change current user to www
#USER www-data

# Expose port 9000 (PHP-FPM default port)
#EXPOSE 9000
EXPOSE 3102

# Start PHP-FPM server
#CMD ["php-fpm"]
CMD ["php", "artisan", "serve", "--port=3102"]
