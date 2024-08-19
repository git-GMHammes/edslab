FROM php:8.2-apache

# -----------------------------
# Linux Layer
# -----------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libaio1 \
    libicu-dev \
    libxml2-dev \
    libpng-dev \
    g++ \
    unixodbc-dev \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd intl pdo pdo_mysql mysqli soap ctype fileinfo

# -----------------------------
# Instalação do Composer
# -----------------------------
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    rm composer-setup.php

# Ativa o mod_rewrite para o Apache
RUN a2enmod rewrite

# Define o diretório de trabalho como /var/www/html
WORKDIR /var/www/html

# Modifica a configuração do DocumentRoot
ENV APACHE_DOCUMENT_ROOT /var/www/html

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Ajusta as permissões no diretório de trabalho
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html

# Comando para iniciar o Apache
CMD ["apache2-foreground"]
