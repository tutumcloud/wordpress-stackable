tutum-docker-wordpress-nosql
======================


Out-of-the-box Wordpress docker image without MySQL


Usage
-----

To create the wordpress service, simply execute the following commands on the tutum-docker-wordpress-nosql folder:

    git clone https://github.com/tutumcloud/tutum-docker-wordpress-nosql.git
    sudo fig up

To install fig, use the following command:

	sudo pip install -U fig

The first time that you run Tutum wordpress service, a new MySQL container will be created, which will then be linked to the wordpress container. You can start using wordpress from your browser with `http://hostname:port/` (by default, you can access the service with `http://localhost/`)

Done!

Configuration
-------------------------------------------------

Edit `fig.yml` to customize the wordpress service before running `sudo fig up`:

The default `fig.yml` shows as follow:

    wordpress:
      build: .
      links: 
       - db
      ports:
       - "80:80"
      environment:
        WORDPRESS_DB_NAME: wordpress
        WORDPRESS_DB_USER: admin
        WORDPRESS_DB_PASS: randpass
    db:
      image: tutum/mysql
      environment:
        MYSQL_PASS: randpass
	
- Change the ports `"80:80"` to map to a different port number: e.g. `"8080:80"` will run wordpress at port `8080`.

- Change the value of `WORDPRESS_DB_NAME`, `WORDPRESS_DB_USER`, `WORDPRESS_DB_PASS` credentials (name, username, password) to connect to MySQL.

- Modify password of admin user in MySQL container by changing the value of `MYSQL_PASS`.

- To use a MariaDB instead of MySQL, you can make the following changes to the `fig.yml` file:

        db:
          image: tutum/mariadb 
          environment:
            MARIADB_PASS: randpass
    And then, change `WORDPRESS_DB_PASS` to the same value as `MARIADB_PASS`.

