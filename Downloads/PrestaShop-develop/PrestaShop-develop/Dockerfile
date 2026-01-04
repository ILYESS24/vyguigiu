# PrestaShop Dockerfile for Render
FROM php:8.1-apache

# Install required system packages and PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libzip-dev \
    libxml2-dev \
    libicu-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    unzip \
    locales \
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
        curl \
        openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP settings for PrestaShop
RUN echo "short_open_tag=Off" > /usr/local/etc/php/conf.d/short_open_tag.ini && \
    echo "memory_limit=256M" > /usr/local/etc/php/conf.d/memory_limit.ini && \
    echo "max_execution_time=300" > /usr/local/etc/php/conf.d/max_execution_time.ini && \
    echo "upload_max_filesize=16M" > /usr/local/etc/php/conf.d/upload_max_filesize.ini && \
    echo "post_max_size=16M" > /usr/local/etc/php/conf.d/post_max_size.ini && \
    echo "max_input_vars=10000" > /usr/local/etc/php/conf.d/max_input_vars.ini && \
    echo "date.timezone=Europe/Paris" > /usr/local/etc/php/conf.d/date_timezone.ini

# Configure locales for internationalization
RUN locale-gen fr_FR.UTF-8 en_US.UTF-8 && \
    update-locale LANG=fr_FR.UTF-8 LC_ALL=fr_FR.UTF-8

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Configure Apache
RUN a2enmod rewrite
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

WORKDIR /var/www/html

# Copy and install dependencies
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Copy application code
COPY . .

# Copy database initialization script
COPY init-db.sql /docker-entrypoint-initdb.d/

# Ensure all PrestaShop files are copied (including localization data)
COPY app/ /var/www/html/app/
COPY bin/ /var/www/html/bin/
COPY cache/ /var/www/html/cache/
COPY classes/ /var/www/html/classes/
COPY config/ /var/www/html/config/
COPY controllers/ /var/www/html/controllers/
COPY docs/ /var/www/html/docs/
COPY download/ /var/www/html/download/
COPY img/ /var/www/html/img/
COPY install-dev/ /var/www/html/install-dev/
COPY js/ /var/www/html/js/
COPY localization/ /var/www/html/localization/
COPY mails/ /var/www/html/mails/
COPY modules/ /var/www/html/modules/
COPY override/ /var/www/html/override/
COPY pdf/ /var/www/html/pdf/
COPY src/ /var/www/html/src/
COPY tests/ /var/www/html/tests/
COPY themes/ /var/www/html/themes/
COPY tools/ /var/www/html/tools/
COPY translations/ /var/www/html/translations/
COPY upload/ /var/www/html/upload/
COPY var/ /var/www/html/var/
COPY webservice/ /var/www/html/webservice/
COPY vendor/ /var/www/html/vendor/

# Create auto-redirect for root access
RUN echo '<?php\n\
// Auto-redirect to admin panel\n\
header("Location: /admin/");\n\
exit;\n\
?>' > /var/www/html/index_redirect.php

# Create pre-configured parameters.php to skip installation
RUN mkdir -p /var/www/html/app/config && \
    echo '<?php\n\
return [\n\
    "parameters" => [\n\
        "database_host" => "mysql",\n\
        "database_port" => "3306",\n\
        "database_name" => "prestashop",\n\
        "database_user" => "root",\n\
        "database_password" => getenv("MYSQL_ROOT_PASSWORD") ?: "prestashop",\n\
        "database_prefix" => "ps_",\n\
        "database_engine" => "InnoDB",\n\
        "cookie_key" => "'$(openssl rand -hex 32)'",\n\
        "cookie_iv" => "'$(openssl rand -hex 8)'",\n\
        "new_cookie_key" => "'$(openssl rand -hex 32)'",\n\
        "ps_caching" => "CacheMemcache",\n\
        "ps_cache_enable" => true,\n\
        "ps_creation_date" => "'$(date +%Y-%m-%d)'",\n\
        "secret" => "'$(openssl rand -hex 32)'",\n\
        "mailer_transport" => "smtp",\n\
        "mailer_host" => "127.0.0.1",\n\
        "mailer_user" => null,\n\
        "mailer_password" => null,\n\
    ],\n\
];' > /var/www/html/app/config/parameters.php

# Create comprehensive .htaccess redirects
RUN echo 'RewriteEngine On\n\
\n\
# Redirect all install-related URLs to admin\n\
RewriteRule ^install/?$ admin/ [R=302,L]\n\
RewriteRule ^install-dev/?$ admin/ [R=302,L]\n\
RewriteRule ^install-dev/(.*)$ admin/ [R=302,L]\n\
\n\
# Block direct access to install directory\n\
RewriteRule ^install/ - [F,L]\n\
RewriteRule ^install-dev/ - [F,L]\n\
\n\
# Prevent access to sensitive files\n\
<FilesMatch "\.(htaccess|htpasswd|ini|log|sh|sql|conf)$">\n\
    Order Allow,Deny\n\
    Deny from all\n\
</FilesMatch>' >> /var/www/html/.htaccess

# Set permissions
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html
RUN chmod -R 777 /var/www/html/var/cache /var/www/html/var/logs /var/www/html/img /var/www/html/download /var/www/html/upload 2>/dev/null || true

EXPOSE 80

CMD ["apache2-foreground"]
