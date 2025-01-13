#!/usr/bin/env bash

docker-compose down
docker-compose build --no-cache postfix
docker-compose up -d