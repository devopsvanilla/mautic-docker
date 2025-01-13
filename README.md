# Mautic  Docker deployment on steroids

*WIP: This is a work in progress and not yet ready for production use.
*

This example demonstrates how to run Mautic with RabbitMQ as the message queue system for handling asynchronous tasks and assume the use of Docker Compose v2 including best practices for running Mautic with RabbitMQ in a containerized environment.

Also adds the possibility of importing files in background (See mautic_web-entrypoint_custom.sh)

## Prerequisites

- [Docker Engine 20.10.0 or newer](https://docs.docker.com/get-started/get-docker/)
- [Docker Compose v2.0.0 or newer](https://docs.docker.com/compose/install/)
- [Git (for cloning the repository)](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Github PAT](./docs/composer-ghpat.md) for downloading composer packages
- [MaxMind Account ID e License Key](https://support.maxmind.com/hc/en-us/articles/4407099783707-Create-an-Account) to download GeoIPLite databse


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
3. Configure the ```.env``` file with your informations

4. Configure the ```.mautic_env``` file with your informations

5. Change sections variables in <b><i>enviroment</i></b> of  <b>docker-compose.yml</b> file for specific settings of each container and also the resources limits of each service as CPU and RAM.

## Deployment

1. Start the services:
```bash
docker compose up -d
bash install-ses-deps.sh #To use the AWS SES service as SMTP Sender
```
2. Monitor the startup process:
```bash
docker compose up -d
````
3. Access Mautic:

- Web Interface: http://localhost:8003 (In the first access the database and the user will be created for access.)

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

## Undeploy containers

Undeploy Containers and delete all associated resources:
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
___
## 🛈 Final words

_Tainage: The solutions mentioned are intellectual ownership of their respective maintainers.It is essential to respect and follow the licenses of use associated with each of them._

_ This implementation is not intended for use in production and does not consider the essential requirements for the processing of massive email campaigns.The purpose of this project is to allow the functional evaluations._

_Enouncement of responsibility: We are not responsible for any damage, loss or problem arising from the use of the mentioned solutions.Compliance with use licenses is the sole responsibility of users._
___

Feito com 💙 por [DevVanilla.guru](https://devopsvanilla.guru)