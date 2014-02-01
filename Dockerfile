FROM tutum/apache-php
MAINTAINER Borja Burgos <borja@tutum.co>

# Install packages
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install supervisor mysql-client

# Download latest version of Wordpress into /app
RUN rm -fr /app && git clone https://github.com/WordPress/WordPress.git /app

# Add wp-config with info for Wordpress to connect to DB
ADD https://raw.github.com/tutumcloud/tutum-docker-wordpress-nosql/master/wp-config.php /app/wp-config.php
RUN chmod 644 /app/wp-config.php

# Add script to create 'wordpress' DB
ADD https://raw.github.com/tutumcloud/tutum-docker-wordpress-nosql/master/run.sh run.sh
RUN chmod 755 /*.sh

# Link app to /var/www for Apache
RUN mkdir -p /app && rm -fr /var/www && ln -s /app /var/www

EXPOSE 80
CMD ["/run.sh","wordpress"]