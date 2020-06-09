#!/bin/bash

docker exec -it laravelApp.app bash -c "composer install && php artisan key:generate && npm install"

exit
