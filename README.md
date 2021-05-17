Based on: [docker-compose-laravel](https://github.com/aschmelyun/docker-compose-laravel)

## Setup

You only need to run the following commands once!

- Clone the repo
- Run `cd aero-setup`
- Run `docker-compose up -d`

The following are built for our web server, with their exposed ports detailed:

- **nginx** - `:80`
- **mysql** - `:3306`
- **php** - `:9000`
- **redis** - `:6379`
- **mailhog** - `:8025` 

## Install Project via Aero CLI

You only need to run the following commands once!

- Run `rm src/.gitkeep` to make `src` empty (aero will not install if the directory is not empty).
- Run `docker exec -it php bash` to run commands in the php container.
- Run `composer require aerocommerce/cli` to install Aero CLI locally.
- Run `vendor/aerocommerce/cli/aero new --no-install` to start the process of installing Aero Commerce.

- Aero cli responses
  - project directory type `project`
  - enter username/password credentials when asked
  - site name: Whatever the site is called
  - change database details to:
    - host: `mysql`
    - port: `3306`
    - db name: `aero`
    - db username: `aero`
    - db password: `aero`
  - change elasticsearch host to: `elasticsearch:9200`

- Run `rm -r vendor composer.json composer.lock` to remove Aero CLI.
- Run `mv project/* project/.* .` to place all files into the `src` directory (ignore the 'can not move...' error messages).
- Run `rm -r project` to remove the `project` folder.

- Run `php artisan aero:install` to start installing Aero.
- Run `exit` to exit the php container.

You should now be able to visit localhost and see the default site. If you cannot see the site/get an nginx error restart with `docker-compose restart`

## To use Redis for cache:

- Open `src/.env` and set `CACHE_DRIVER=redis` and `REDIS_HOST=redis`.
- Restart Docker `docker-compose restart`.

## Populate the catalog:

- Run `docker exec -it php bash` to run commands in the php container.
- Run `php artisan aero:import:products:csv https://aero-data.s3.eu-west-2.amazonaws.com/products.csv`
- Elastic search may need rebuilding `php artisan aero:search:rebuild`

## Login to the admin area:

- http://localhost/admin
- username: `admin@example.com`
- password: `aerocommerce`

## Docker Play

If you want to test it on [https://labs.play-with-docker.com](https://labs.play-with-docker.com) then you will need to do the following:

- Run `docker exec -it php bash` to run commands in the php container.
- Run `chmod -R 777 /var/www/html/storage/` to set file permissions.
## Post installation usage

- Run `docker-compose up -d` to start the server.
- Run `docker-compose stop` to stop the server.

## How to run artisan commands from outside the container:

For example to view a list of all available Artisan commands from outside the container, run `docker exec -it php php artisan list`.

## MailHog

The current version of Laravel (8 as of today) uses MailHog as the default application for testing email sending and general SMTP work during local development. Using the provided Docker Hub image, getting an instance set up and ready is simple and straight-forward. The service is included in the `docker-compose.yml` file, and spins up alongside the webserver and database services.

To see the dashboard and view any emails coming through the system, visit [localhost:8025](http://localhost:8025).