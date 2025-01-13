#!/usr/bin/env bash

apt-get update
apt-get upgrade -y
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt-get install -y nodejs
apt-get install -y git

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
cd /var/www/html
composer config --global github-oauth.github.com $COMPOSER_GHPAT
composer require pabloveintimilla/mautic-amazon-ses
#php bin/console mautic:plugins:reload
rm -rf /var/www/html/var/cache/prod
php bin/console cache:clear

/entrypoint.sh