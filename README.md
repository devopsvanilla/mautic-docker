# Mautic  Docker deployment on steroids

*WIP: This is a work in progress and not yet ready for production use.
*

This example demonstrates how to run Mautic with RabbitMQ as the message queue system for handling asynchronous tasks and assume the use of Docker Compose v2 including best practices for running Mautic with RabbitMQ in a containerized environment.

Also adds the possibility of importing files in background (See mautic_web-entrypoint_custom.sh)

## Prerequisites

- [Docker Engine 20.10.0 or newer](https://docs.docker.com/get-started/get-docker/)
- [Docker Compose v2.0.0 or newer](https://docs.docker.com/compose/install/)
- [Git (for cloning the repository)](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Directory Structure
```
rabbitmq-worker/                     # Root project directory
├── .env                             # Docker Compose Global environment variables
├── .mautic_env                      # Docker Compose Mautic specific environment variables
├── docker-compose.yml               # Docker Compose configuration file
├── mautic_web-entrypoint_custom.sh  # Custom Docker Image Entrypoint for Docker Mautic Image used in Web container
├── undeploy.sh                      # Undeploy application from you Docker Host
├── volumes/                         # Created at execution for container storage
│   ├── mautic/                      # Mautic specific shared directories
│   │   ├── config/                  # Configuration files
│   │   ├── cron/                    # Cron files
│   │   ├── logs/                    # Application logs
│   │   └── media/                   # Media storage
│   │       ├── files/               # Uploaded files
│   │       └── images/              # Uploaded images
│   ├── mysql/                       # MySQL data storage
│   ├── rabbitmq/                    # RabbitMQ data storage
└── README.md                        # This file instructions
```

## Configuration

1. Optional: Create the directories specified by the volumes in docker-compose.yml for custom settings. Refer to the [README.md](../../README.md) file in the root of this repository for detailed instructions:

```bash
mkdir -p volumes/mautic/{config,cron,media/{files,images}}
```

2. Copy the example environment files:

```bash
cp .env.example .env
cp .mautic_env.example .mautic_env
```
3. Configure the .env file with your database settings:
```bash
COMPOSE_PROJECT_NAME=rabbitmq-worker
COMPOSE_NETWORK=${COMPOSE_PROJECT_NAME}-docker

MYSQL_HOST=db.${COMPOSE_NETWORK}
MYSQL_PORT=3306
MYSQL_DATABASE=mautic_db
MYSQL_USER=mautic_db_user
MYSQL_PASSWORD=mautic_db_pwd
MYSQL_ROOT_PASSWORD=changeme

PHP_INI_VALUE_MEMORY_LIMIT=1536M

RABBITMQ_DEFAULT_USER=mautic
RABBITMQ_DEFAULT_PASS=mautic
RABBITMQ_DEFAULT_VHOST=mautic
RABBITMQ_NODE_PORT=5672
RABBITMQ_MANAGEMENT_PORT=15672
```

4. Configure the .mautic_env file with RabbitMQ settings:
```bash
MAUTIC_DB_HOST="${MYSQL_HOST}"
MAUTIC_DB_PORT="${MYSQL_PORT}"
MAUTIC_DB_DATABASE="${MYSQL_DATABASE}"
MAUTIC_DB_USER="${MYSQL_USER}"
MAUTIC_DB_PASSWORD="${MYSQL_PASSWORD}"

MAUTIC_MESSENGER_DSN_EMAIL="amqp://${RABBITMQ_DEFAULT_USER}:${RABBITMQ_DEFAULT_PASS}@rabbitmq:5672/mautic/messages"
MAUTIC_MESSENGER_DSN_HIT="amqp://${RABBITMQ_DEFAULT_USER}:${RABBITMQ_DEFAULT_PASS}@rabbitmq:5672/mautic/messages"

DOCKER_MAUTIC_RUN_MIGRATIONS=false
DOCKER_MAUTIC_LOAD_TEST_DATA=false
```

5. Change sections variables in <b><i>enviroment</i></b> of  <b>docker-compose.yml</b> file for specific settings of each container and also the resources limits of each service as CPU and RAM.

## Deployment

1. Start the services:
```bash
docker compose up -d
```
2. Monitor the startup process:
```bash
docker compose up -d
````
3. Access Mautic:

- Web Interface: http://localhost:8003

- RabbitMQ Management Interface: http://localhost:15672 (default credentials: guest/guest)

## Logs
#### View Mautic logs:
```bash
cd ./volumes/mautic/logs
ls -la
```
#### View RabbitMQ logs:
```bash
docker compose logs rabbitmq
````

## Backup

Backup for all services can be done from the directory [./volumes](./volumes) created at the Docker Engine host.


## Scaling Workers

#### To scale the number of worker containers:
```bash
docker compose up -d --scale mautic_worker=3
```

## Undeploy containers

Undeplay Containers and delete all associated resources:
```bash
bash undeploy.sh
```

## Troubleshooting

#### Check service health:
```bash
docker compose ps
```

## Security Considerations
- Change default RabbitMQ credentials in production
- Enable SSL/TLS for RabbitMQ connections
- Regularly update all containers to their latest versions
- Monitor queue sizes and consumer health
- Implement proper backup strategies

## Additional Official Resources
- [Mautic Website](https://github.com/mautic)
- [Mautic Documentation](https://docs.mautic.org/en/5.x/)
- [Mautic Forum](https://forum.mautic.org/)
- [Mautic at Docker Hub](https://hub.docker.com/r/mautic/mautic)
- [Mautic at GitHub](https://github.com/mautic)
- [RabbitMQ Documentation](https://www.rabbitmq.com/docs)
- [Docker Documentation](https://docs.docker.com/compose/)
