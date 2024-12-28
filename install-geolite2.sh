#!/usr/bin/env bash

sudo add-apt-repository ppa:maxmind/ppa
sudo apt update
sudo apt install geoipupdate

/var/www/html/var/cache/prod/ip_data
