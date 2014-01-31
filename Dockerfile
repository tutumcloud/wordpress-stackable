FROM tutum/apache-php
MAINTAINER Borja Burgos <borja@tutum.co>

# Add wp-config with info for Wordpress to connect to DB
ADD https://raw.github.com/tutumcloud/tutum-docker-wordpress-nosql/master/wp-config.php /app/wp-config.php

# Add script to create 'wordpress' DB
ADD https://raw.github.com/tutumcloud/tutum-docker-wordpress-nosql/master/create_db.sh create_db.sh
RUN chmod 755 /*.sh

# Download latest version of Wordpress into /app
RUN rm -fr /app && git clone https://github.com/WordPress/WordPress.git /app

# Set up local database
RUN /create_db.sh wordpress

# Link app to /var/www for Apache
RUN mkdir -p /app && rm -fr /var/www && ln -s /app /var/www

EXPOSE 80

CMD ["/run.sh"]