#!/bin/bash

# The execution of the composer requires a Github Pat. See ./docs/composer-ghpat.md
export COMPOSER_GHPAT="ghp_GwmId1cNOqYG6wD5Ns3n3ICDAhtAPz0Jq7Yq"

# Obtenha a lista de containers em execução que começam com "mautic"
containers=$(docker ps --filter "name=^/docker_mautic-mautic" --format "{{.ID}}:{{.Names}}")

# Verifique se há containers correspondentes
if [ -z "$containers" ]; then
  echo "Nenhum container encontrado que começa com 'mautic'."
  exit 1
fi

# Execute os comandos em cada container encontrado
for container_info in $containers; do
  container_id=$(echo $container_info | cut -d: -f1)
  container_name=$(echo $container_info | cut -d: -f2)

  echo "Instalar as dependencias no container $container_name? (s/n)"
  read -r resposta
  if [ "$resposta" = "s" ]; then
    echo "Instalando as dependências no container $container_name ($container_id)..."
    docker exec $container_id sh -c "
      apt-get update
      apt-get upgrade -y
      curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
      apt-get install -y nodejs
      apt-get install -y git
      apt-get install -y gettext-base

      curl -sS https://getcomposer.org/installer | /usr/local/bin/php
      mv composer.phar /usr/local/bin/composer
      cd /var/www/html
      composer config --global github-oauth.github.com $COMPOSER_GHPAT

      php /var/www/html/bin/console mautic:marketplace:install -vvv matbcvo/mautic-amazon-sns-callback
      composer require symfony/amazon-mailer

      rm -rf /var/www/html/var/cache/prod
      php /var/www/html/bin/console cache:clear
	    php /var/www/html/bin/console cache:warmup
      chown -R www-data:www-data /var/www/html/var

    "
  fi
done

container_id=$(docker ps --filter "name=^/docker_mautic-rabbitmq" --format "{{.ID}}")
echo "Criar as filas no container docker_mautic-rabbitmq? (s/n)"
read -r resposta
if [ "$resposta" = "s" ]; then
  docker exec $container_id sh -c " \
    rabbitmqctl add_vhost mautic/messages
    rabbitmqctl add_vhost mautic/failed
    rabbitmqctl set_permissions -p mautic/messages mautic '.*' '.*' '.*'
    rabbitmqctl set_permissions -p mautic/failed mautic '.*' '.*' '.*'
  "
fi

echo "Instalação concluída."
