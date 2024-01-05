FROM php:8.1-fpm

WORKDIR /var/www

# Install system dependencies
RUN apt-get update -qq && apt-get install -y build-essential libicu-dev libzip-dev libpng-dev libonig-dev libpq-dev zip unzip curl && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install bcmath mbstring pcntl intl zip opcache gd
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo pdo_pgsql pgsql
COPY ./php.ini /usr/local/etc/php/php.ini

# Get latest Composer
##COPY composer.lock composer.json /var/www/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Add user for laravel application
RUN groupadd -g 1000 www && useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents
##COPY . /var/www

# Copy existing application directory permissions
##COPY --chown=www:www . /var/www

COPY script.sh /usr/bin/
RUN chmod 777 /usr/bin/script.sh
# Change current user to www
USER www

CMD ["php-fpm"]
