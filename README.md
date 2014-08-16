tutum-docker-wordpress-nosql
============================


Out-of-the-box Wordpress docker image without MySQL


Usage
-----

To create the image `tutum/wordpress-stackable`, execute the following command on the `tutum-docker-wordpress-nosql` folder:

    docker build -t tutum/wordpress-stackable .

To create a MySQL database:

    docker run -d -e MYSQL_PASS='<your_password>' --name database -p 3306:3306 tutum/mysql:5.5

To run Wordpress by linking to the database created above:

    docker run -d --link database:DB  -e DB_PASS='<your_password>' -p 80:80 tutum/wordpress-stackable

Now, you can use your web browser to access Wordpress from the the follow address:

    `http://localhost/`

Usage (using fig)
-----------------

To create the wordpress service, simply execute the following commands on the tutum-docker-wordpress-nosql folder:

    fig up

To install fig, use the following command:

    pip install -U fig

The first time that you run Tutum wordpress service, a new MySQL container will be created, which will then be linked to the wordpress container. You can start using wordpress from your browser with `http://hostname:port/` (by default, you can access the service with `http://localhost/`)

Done!

Configuration(Fig)
------------------

Edit `fig.yml` to customize the wordpress service before running `fig up`:

The default `fig.yml` shows as follow:

    wordpress:
      build: .
      links:
       - db
      ports:
       - "80:80"
      environment:
        DB_NAME: wordpress
        DB_USER: admin
        DB_PASS: "**ChangeMe**"
        DB_HOST: "**LinkMe**"
        DB_PORT: "**LinkMe**"
    db:
      image: tutum/mysql:5.5
      environment:
        MYSQL_PASS: "**ChangeMe**"
	
- Change the ports `"80:80"` to map to a different port number: e.g. `"8080:80"` will run wordpress at port `8080`.

- Change the value of `DB_NAME`, `DB_PASS` credentials (name, password) to connect to MySQL. Value of `DB_USER` must be `admin` at this moment.

- Modify password of admin user in MySQL container by changing the value of `MYSQL_PASS`, must be the same value of `DB_PASS`.

- To use a MariaDB instead of MySQL, you can make the following changes to the `fig.yml` file:

        db:
          image: tutum/mariadb:latest
          environment:
            MARIADB_PASS: randpass

    And then, change `DB_PASS` to the same value as `MARIADB_PASS`.

