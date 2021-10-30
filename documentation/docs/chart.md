---
sidebar_position: 3
---

# Chart

This chart will deploy following components:
* PostgreSQL single instance / pod 

:::note
For production grade installations it is recommended to use an external PostgreSQL). 
Alternatively users may want to install Postgres HA on Kubernetes. For more information, 
refer [Crunchy PostgreSQL Operator](https://www.crunchydata.com/products/crunchy-postgresql-for-kubernetes/
:::

* RabbitMQ in highly available configuration
* HAProxy ingress controller
* Digital.ai Deploy multiple masters and workers


:::note
Satellites are expected to be deployed outside the Kubernetes cluster.
:::
