#!/bin/sh

rabbitmqctl add_vhost ${RABBITMQ_DEFAULT_VHOST}/${RABBITMQ_DEFAULT_MESSAGESQUEUE}

rabbitmqctl add_vhost ${RABBITMQ_DEFAULT_VHOST}/${RABBITMQ_DEFAULT_MESSAGESQUEUE}

rabbitmqctl set_permissions -p mautic/messages mautic ".*" ".*" ".*"