FROM ubuntu:20.04
WORKDIR /api
COPY composer.json composer.lock /api/
RUN apt-get update
RUN apt-get install software-properties-common -y
RUN add-apt-repository -y ppa:ondrej/php
#RUN apt-get update && apt-get install -y \
#    php7.4-fpm \
#    php7.4-common \
#    php7.4-mysql \
#    php7.4-xml \
#    php7.4-mbstring


RUN apt-get update && apt-get install -y \
    php8.1-fpm \
    php8.1-common \
    php-mysql \
    php8.1-xml \
    php8.1-mongodb \
    php8.1-mbstring \
    nginx

#COPY default /etc/nginx/sites-enabled

RUN /etc/init.d/nginx reload
RUN service nginx restart

RUN apt-get install curl -y
# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer2
RUN apt-get install php8.1-curl -y
RUN apt-get install git -y 
#modified php.ini(upload file size)
#COPY php.ini /etc/php/8.1/fpm


#COPY . /var/www/html

COPY . /api
#RUN chmod a+rw -R /api/storage/logs
#RUN chmod -R ugo+rw /api/storage/logs
RUN mkdir /run/php
RUN composer2 self-update
#RUN composer2 require jenssegers/mongodb
RUN composer2 config disable-tls true
#ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer2 update composer.lock
RUN COMPOSER_PROCESS_TIMEOUT=1200; composer2 install
#RUN chmod +x hosts.sh
#COPY .env /api
#RUN php artisan key:generate
#CMD ["php-fpm8.1", "-F"]
CMD ["sh", "hosts.sh"]

