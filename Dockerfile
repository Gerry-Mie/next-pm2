# Start with the official PHP 8.2 FPM image based on Alpine
FROM php:8.2-fpm

# Set working directory
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
