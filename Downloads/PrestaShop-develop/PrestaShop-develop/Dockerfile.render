# Dockerfile optimisé pour Render (512MB RAM)
FROM php:8.1-apache

# Configuration mémoire stricte
ENV PHP_MEMORY_LIMIT=128M
ENV UPLOAD_MAX_FILESIZE=8M
ENV POST_MAX_SIZE=8M
ENV MAX_EXECUTION_TIME=30

# Désactiver les services inutiles pour économiser la RAM
ENV DISABLE_CRON=1
ENV DISABLE_MAILHOG=1

# Installer les extensions PHP essentielles uniquement
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libzip-dev \
    libxml2-dev \
    libicu-dev \
    unzip \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install \
        pdo_mysql \
        mysqli \
        gd \
        zip \
        intl \
        mbstring \
        xml \
        bcmath \
        opcache \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Optimisations OPcache pour 512MB
RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.memory_consumption=32" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.max_accelerated_files=7963" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.revalidate_freq=0" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.validate_timestamps=0" >> /usr/local/etc/php/conf.d/opcache.ini

# Configuration PHP optimisée pour faible RAM
RUN echo "memory_limit=${PHP_MEMORY_LIMIT}" > /usr/local/etc/php/conf.d/memory-limit.ini && \
    echo "upload_max_filesize=${UPLOAD_MAX_FILESIZE}" > /usr/local/etc/php/conf.d/upload-limit.ini && \
    echo "post_max_size=${POST_MAX_SIZE}" > /usr/local/etc/php/conf.d/post-limit.ini && \
    echo "max_execution_time=${MAX_EXECUTION_TIME}" > /usr/local/etc/php/conf.d/execution-time.ini && \
    echo "max_input_time=30" >> /usr/local/etc/php/conf.d/execution-time.ini

# Installer Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Configuration Apache optimisée
RUN a2enmod rewrite && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    echo "StartServers 1" >> /etc/apache2/apache2.conf && \
    echo "MinSpareServers 1" >> /etc/apache2/apache2.conf && \
    echo "MaxSpareServers 2" >> /etc/apache2/apache2.conf && \
    echo "MaxRequestWorkers 10" >> /etc/apache2/apache2.conf

# Créer l'utilisateur www-data avec UID/GID spécifiques
RUN usermod -u 1000 www-data && \
    groupmod -g 1000 www-data

WORKDIR /var/www/html

# Copier et installer les dépendances
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

# Copier le reste du code
COPY . .

# Configuration de production
COPY config/defines_prod.inc.php config/defines.inc.php 2>/dev/null || true
COPY .htaccess.production .htaccess 2>/dev/null || true

# Permissions optimisées
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html && \
    chmod -R 777 /var/www/html/var/cache /var/www/html/var/logs /var/www/html/img /var/www/html/download /var/www/html/upload 2>/dev/null || true

# Nettoyer les caches de développement
RUN rm -rf /var/www/html/var/cache/* 2>/dev/null || true && \
    rm -rf /var/www/html/tests 2>/dev/null || true && \
    rm -rf /var/www/html/docs 2>/dev/null || true

# Health check léger
HEALTHCHECK --interval=60s --timeout=10s --start-period=30s --retries=3 \
    CMD php -r "echo 'OK';" || exit 1

# Port
EXPOSE 80

# Démarrer Apache en mode production
CMD ["apache2-foreground"]
