---
sidebar_position: 7
---

# Upgrading Helm Chart

:::caution
This is internal documentation. This document can be used only if it was recommended by the Support Team.
:::

:::caution
From 10.2 version helm chart is not used directly. Use operator based installation instead.
:::

:::caution
From 23.3 version this document is outdated. Use official Digital.ai documentation.
:::

To upgrade the version `ImageTag` parameter needs to be updated to the desired version. To see the list of available ImageTag for Digital.ai Deploy, refer the following links [Deploy_tags](https://hub.docker.com/r/xebialabs/xl-deploy/tags). For upgrade, Rolling Update strategy is used.
To upgrade the chart with the release name `xld-production`, execute below command: 
```bash
helm upgrade xld-production xl-deploy-kubernetes-helm-chart/
```

:::note
Currently upgrading custom plugins and database drivers is not supported. 
In order to upgrade custom plugins and database drivers, users need to build custom docker image of Digital.ai Deploy 
containing required files.See the [adding custom plugins](https://docs.xebialabs.com/v.9.7/deploy/how-to/customize-xl-up/#adding-custom-plugins) 
section in the the Digital.ai (formerly Xebialabs) official documentation.
:::
	
### Existing or External Databases
There is an option to use external PostgreSQL database for your Digital.ai Deploy.
Configure values.yaml file accordingly.
If you want to use an existing database,  these steps need to be followed:
- Change `postgresql.install` to false
- `UseExistingDB.Enabled`: true
- `UseExistingDB.XL_DB_URL`: `jdbc:postgresql://<postgres-service-name>.<namsepace>.svc.cluster.local:5432/<xld-database-name>`
- `UseExistingDB.XL_DB_USERNAME`: Database User for xl-deploy
- `UseExistingDB.XL_DB_PASSWORD`: Database Password for xl-deploy

**Example:**
```bash
#Passing a custom PostgreSQL to XL-Deploy
UseExistingDB:
  Enabled: true
  # If you want to use existing database, change the value to "true".
  # Uncomment the following lines and provide the values.
  XL_DB_URL: jdbc:postgresql://xld-production-postgresql.default.svc.cluster.local:5432/xld-db
  XL_DB_USERNAME: postgres
  XL_DB_PASSWORD: postgres
``` 
 
:::note 
User might have database instance running outside the cluster. Configure parameters accordingly.
:::

### Existing or External Messaging Queue
If you plan to use an existing messaging queue, follow these steps to configure values.yaml
- Change `rabbitmq-ha.install` to false
- `UseExistingMQ.Enabled`: true
- `UseExistingMQ.XLD_TASK_QUEUE_USERNAME`: Username for xl-deploy task queue
- `UseExistingMQ.XLD_TASK_QUEUE_PASSWORD`: Password for xl-deploy task queue
- `UseExistingMQ.XLD_TASK_QUEUE_URL`: `amqp://<rabbitmq-service-name>.<namsepace>.svc.cluster.local:5672`
- `UseExistingMQ.XLD_TASK_QUEUE_DRIVER_CLASS_NAME`: Driver class name for  xl-deploy task queue

**Example:**
```bash
# Passing a custom RabbitMQ to XL-Deploy
UseExistingMQ:
  Enabled: true
  # If you want to use an existing Message Queue, change 'rabbitmq-ha.install' to 'false'.
  # Set 'UseExistingMQ.Enabled' to 'true'.Uncomment the following lines and provide the values.
  XLD_TASK_QUEUE_USERNAME: guest
  XLD_TASK_QUEUE_PASSWORD: guest
  XLD_TASK_QUEUE_URL: amqp://xld-production-rabbitmq-ha.default.svc.cluster.local:5672/%2F
  XLD_TASK_QUEUE_DRIVER_CLASS_NAME: com.rabbitmq.jms.admin.RMQConnectionFactory
```


:::note
User might have rabbitmq instance running outside the cluster. Configure parameters accordingly.
:::

### Existing Ingress Controller
There is an option to use external ingress controller for Digital.ai Deploy.
If you want to use an existing ingress controller,  change `haproxy.install` to false.
