---
sidebar_position: 22
---

#  Planning migration of an existing Digital.ai Deploy installation to Kubernetes (v23.3 and v24.1)

:::caution
This is internal documentation.
The document can be used only if it was recommended by the Support Team.
:::

:::caution
This document is for a Deploy version from 23.3 and up.
:::

Following steps should cover the general process for planning move of your Digital.ai Deploy software onto a Kubernetes platform.
Note that details can vary depending on your specific situation, needs, and pre-existing infrastructure.

:::warning
This guide is technical in nature. Before starting the migration process, make sure you have a proficient level of understanding about your 
existing infrastructure, Kubernetes, and the Digital.ai Deploy products.
If you have more specific questions about any of these steps, feel free to ask!
:::

## 1. Preparation

Make sure all necessary prerequisites are in place. These include things like:
- setting up your Kubernetes cluster, 
- installing and configuring required Kubernetes CLI tools, 
- preparing necessary information for PostgreSQL and RabbitMQ servers if existing ones are to be used.

:::tip
Read through the xl kube workshop to gain a comprehensive understanding of how to install or upgrade Digital.ai Deploy or Release or Remote Runner on a kubernetes cluster.
See:
- [xl-kube-workshop](https://github.com/xebialabs/xl-kube-workshop)
- [Helm chart documentation](https://github.com/xebialabs/xl-deploy-kubernetes-helm-chart/tree/23.3.x-maintenance) - the Deploy operator is managing Deploy helm chart on K8S cluster
:::

This manual is for 23.3 and 24.1 versions (or above). 
The target version of Deploy needs to be aligned with tools used (xl), and supported java version. 
Also, the version of on-prem Deploy before migration needs to be the same to the target version of the Deploy that will be installed on K8S cluster.

### 1.1. Requirements for Client Machine

#### Mandatory
- Installed [xl](https://dist.xebialabs.com/public/xl-cli/) - same version of the Deploy you plan to install on K8S cluster
  - [Install the XL CLI](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/how-to/install-the-xl-cli.html)
- Installed [yq](https://github.com/mikefarah/yq) 4.18.1 or higher.
- Installed [kubectl](https://kubernetes.io/docs/tasks/tools/) version +/-1 from the target K8S cluster version.
- Network connection to the selected K8S cluster with kubectl context setup

#### Optional
- Installed Java 11/17 - keytool (only if you plan to use the generation of the keystore from the xl-cli kube) - the version depends on Deploy's Java version
- Installed [helm](https://helm.sh/docs/intro/install/) - if you would like to get additional info during installation - the latest version
- Installed docker image registry compatible cli to push/pull images - if you need to pull/push images from `docker.io` to the private K8S image registry
  - [docker-cli](https://docs.docker.com/get-docker/)
  - [podman-cli](https://podman.io/docs/installation) - as alternative to docker cli to push/pull images

### 1.2. Select the Desired Cloud Platform for Migration

The migration supports multiple platforms including (here are also links with some details that are important for the specific provider):
- Plain Multi-node Kubernetes Cluster On-premise, 
- OpenShift (on [AWS](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/operator/xl-op-install-on-aws-openshift.html), Azure and on other providers), 
- [Amazon EKS](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/operator/xl-op-install-on-eks.html), 
- [Google GKE](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/operator/xl-op-install-on-gke.html), and 
- [Azure AKS](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/operator/xl-op-install-on-aks.html).

### 1.3. Provide Docker Image Tags

While the default (latest) Docker image tags will be used, it's possible to verify all available tags using the corresponding Docker Hub links. 

Here is the list of images for 23.3 version: [Prerequisite Images](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/operator/xl-op-setup-custom-image-registry.html#step-1-get-prerequisite-images).
Check if all images are available on your K8s cluster.

If you plan to use private image registry, check how to setup it during installation: 
[Install or Upgrade Deploy on an Air-gaped Environment](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/operator/xl-op-deploy-airgapped-install.html)

### 1.4. Deploy Server Replicas

Estimate the number of master and worker replicas required for your Deploy installation and the resources that are needed on cluster. 
With that estimate check have you enough the number of nodes in the K8S cluster. 

### 1.5. Configure your Kubernetes Cluster

#### 1.5.1. Resource Sizing

Plan the sizing of the pods master/worker resources. Check resources that are needed for normal installation, the sizing of the master and worker pods should be the same:
   - [External Worker Hardware Configuration](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/concept/requirements-for-installing-xl-deploy.html#external-worker-hardware-configuration)
   - [Hard Disk](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/concept/requirements-for-installing-xl-deploy.html#hard-disk)

#### 1.5.2. Namespace

Define a namespace for the installation. By default, it's `digitalai`, but a custom namespace can be used.

Choose the Ingress Controller to use. Nginx and HAProxy are supported, or you can use existing ingress class from K8S cluster, or no ingress.
- You will need a registered domain name (FQDN) to access the UI.
- Possibly enable SSL/TLS protocols in your cluster. If so, you will need to create a TLS certificate and key as a secret in your cluster.

#### 1.5.3. License

Have a valid license for the services to be installed. License files can be in plain text format or base64 encoded format. 
See [Licensing the Deploy Product](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/concept/xl-deploy-licensing.html)

#### 1.5.4. Repository Keystore File
   
Copy your repository keystore file `repository-keystore.jceks` and keystore password in clear-text from the Deploy conf directory to the client machine. 
The keystore file is in the `conf` directory of your existing Deploy instance: `conf/repository-keystore.jceks`, it contains an encryption key for DB repository.
You need to reuse that file during `xl kube install` installation in the step 6.1.

#### 1.5.5. Relational Database

Choose whether you will be using database:
- an existing relational database server supported by Deploy's target version, or 
- create new one external relational database supported by Deploy, or 
- create a new one PostgreSQL database during the installation that will run inside the Kubernetes cluster. 
If the former, there is some required information you will need to gather. Check the list of supported databases and version, and storage sizing:
- [Supported Databases](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/concept/requirements-for-installing-xl-deploy.html#supported-databases)
- [Database Server Hardware Configuration](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/concept/requirements-for-installing-xl-deploy.html#database-server-hardware-configuration)
- [Using an Existing PostgreSQL Database](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/operator/xl-op-deploy-external-db.html)

:::note
If you plan to use an external database, pay attention to the latency between your cluster and DB instance, it will play a big part in the final Deploy performance.
:::

#### 1.5.6. Message Queue

The same decision and process also applies to RabbitMQ server (as for Relational Database).

- [Using an Existing RabbitMQ Message Queue](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/operator/xl-op-deploy-external-mq.html)

#### 1.5.7. Authentication

Optionally, configure OIDC for authentication. It can be:
- an existing server such as [Keycloak](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/concept/deploy-oidc-with-keycloak.html), [Okta, Azure Active Directory](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/concept/xl-deploy-oidc-authentication.html);
- integrated with [Digital.ai's Identity Service platform](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/how-to/deploy-integrating-with-identity-service.html); 
- integrated with [LDAP](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/how-to/setup-and-configuration-LDAP-with-deploy.html) 
- or use no OIDC authentication in favor of Digital.ai's own DB-based local user authentication.

Check the selection details in the documentation [SSO Authentication Options](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/concept/deploy-plan-your-sso-authentication.html)

Configuration of the OIDC part is done during xl kube installation, check documentation: [Select the Type of OIDC Configuration](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/operator/xl-op-deploy-install-oidc-configuration.html)

:::note
If you plan to use an LDAP, it requires update of the file `conf/deployit-security.xml`, there is an example how to customize that file in 
[dai-deploy_cr-example.yaml](./yamls/dai-deploy_cr-example.yaml). Check the section in the file 
`spec.master.extraConfiguration.default-conf_deployit-security` and `spec.worker.extraConfiguration.default-conf_deployit-security`, and in this document section 6.3. how to do changes. 
:::

#### 1.5.8. Storage

Estimate PVC size for Deploy masters and workers, PostgreSQL, and RabbitMQ:
- [Hard Disk](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/concept/requirements-for-installing-xl-deploy.html#hard-disk)
- [Database Server Hardware Configuration](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/concept/requirements-for-installing-xl-deploy.html#database-server-hardware-configuration)
   
Select the storage class, for the Deploy is enough to use any ReadWriteOnce access mode supported storage class.
Default storage classes are created in Kubernetes clusters that run Kubernetes version 1.22 or later, but you can create your own to suit your needs.
Check details on the tested storage classes: [Storage class support (not public, ask for the copy)](https://digitalai.atlassian.net/wiki/spaces/Labs/pages/77226606593/Storage+class+support)

## 2. Upgrade Deploy on the Target Version

It is expected that migration of the Deploy to the K8S cluster will be done with the same version of the Deploy (during the migration, there will be no upgrade of the version).

For more details, check [Upgrade Deploy 10.1.x or Later to Current](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/how-to/upgrade-xl-deploy.html)

## 3. Switch Artifact Storage to Database

The K8S version of the Deploy is working with the database artifact storage.
In case you are already using the database, you have the following configuration: 

`XL_DEPLOY_SERVER_HOME/centralConfiguration/deploy-repository.yaml`
```yaml
xl.repository:
  artifacts:
    type: db
```

In the other way for more details, check:
- [Move artifacts from the file system to a database](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/how-to/move-artifacts.html)
- [Configure the Database and Artifacts Repository](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/how-to/configure-the-xl-deploy-sql-repository.html)

## 4. Switch Plugin Source to Database

The K8S version of the Deploy is working with the database plugin source. 
In case you are already using the database - `-plugin-source database`, skip this section.

In the other way for more details, check:
- [Plugin synchronization](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/concept/plugins-synchronization.html)

With this option enabled before migration, all plugins will be stored in the database. 

## 5. Backup Current Installation

### 5.1. Drain Ongoing Tasks from Deploy 

- Log in to your existing Deploy instance as an administrator, click Explorer, expand Monitoring, double click Deployment tasks, and select All Tasks.
- If there are any tasks with a state of Failing or Failed, cancel them.
- If there are any tasks with a state of Executing, wait for them to complete or cancel them.
- To open a task from Monitoring, double-click it.
- Ensure that no new tasks are started by enabling [maintenance mode](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/how-to/enable-xl-deploy-maintenance-mode.html).

### 5.2. Shut down the existing Deploy server.

### 5.3. Backup database

Back up your database installations, here is an example with a separated main and report PostgreSQL database:
```shell
mkdir -p /tmp/postgresql/backup
pg_dump -U xld xld-db | gzip > /tmp/postgresql/backup/pg_dump-xld-db.sql.gzip
# execute this if you have separate xld-report-db 
pg_dump -U xld-report xld-report-db | gzip > /tmp/postgresql/backup/pg_dump-xld-report-db.sql.gzip
```

Use the database username and password according to your PostgreSQL database setup.

:::note
Make sure that the directory where you are storing backup has enough free space.
:::

### 5.4. Backup all customized Deploy directories

For example, possible changes could be in directories:
- conf
- ext
- hotfix
- work

See details for the backup: [Back up Deploy](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/how-to/back-up-xl-deploy.html)

## 6. Installation Deploy Digital.ai on K8S Cluster

### 6.1. Generate K8S Configuration

Use the 
```shell
xl kube install --dry-run
```
command from the XL CLI to generate initial installation files for Digital.ai Deploy.

During execution, you will need prepared items from section 1.5.
Use the collected information from the previous steps to answer the questions and do initial generation of the resource files for the target namespace.
About setup check for details in the documentation:
- [Installation Options Reference for Digital.ai Deploy](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/operator/xl-op-install-wizard-deploy.html)
- [XL Kube Command Reference](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/operator/xl-kube.html)

The last few lines of the command run will be similar following log:

```log
For current process files will be generated in the: digitalai/dai-deploy/digitalai/20240108-120535/kubernetes
Generated answers file successfully: digitalai/generated_answers_dai-deploy_digitalai_install-20240108-120535.yaml
Starting install processing.
Skip creating namespace digitalai, already exists
Generated files successfully for PlainK8s installation.
Applying resources to the cluster!
Skipping apply the file /tmp/dai/digitalai/dai-deploy/digitalai/20240108-120535/kubernetes/template/controller-manager-metrics-service.yaml
Skipping apply the file /tmp/dai/digitalai/dai-deploy/digitalai/20240108-120535/kubernetes/template/custom-resource-definition.yaml
Skipping apply the file /tmp/dai/digitalai/dai-deploy/digitalai/20240108-120535/kubernetes/template/deployment.yaml
Skipping apply the file /tmp/dai/digitalai/dai-deploy/digitalai/20240108-120535/kubernetes/template/leader-election-role.yaml
Skipping apply the file /tmp/dai/digitalai/dai-deploy/digitalai/20240108-120535/kubernetes/template/leader-election-rolebinding.yaml
Skipping apply the file /tmp/dai/digitalai/dai-deploy/digitalai/20240108-120535/kubernetes/template/manager-role.yaml
Skipping apply the file /tmp/dai/digitalai/dai-deploy/digitalai/20240108-120535/kubernetes/template/manager-rolebinding.yaml
Skipping apply the file /tmp/dai/digitalai/dai-deploy/digitalai/20240108-120535/kubernetes/template/proxy-role.yaml
Skipping apply the file /tmp/dai/digitalai/dai-deploy/digitalai/20240108-120535/kubernetes/template/proxy-rolebinding.yaml
Skipping apply the file /tmp/dai/digitalai/dai-deploy/digitalai/20240108-120535/kubernetes/dai-deploy_cr.yaml
Install finished successfully!
```

:::note
In the next steps we will do updates to the CR yaml file, to reflect all the custom changes that are already available on the on-prem Deploy installation. 
The changes will go mainly in the custom-resource (CR) yaml file that is in our case: `/tmp/dai/digitalai/dai-deploy/digitalai/20240108-120535/kubernetes/dai-deploy_cr.yaml`, 
we will refer it from now with `dai-deploy_cr.yaml` name.

At the end of migration, the generated files from this step will be applied on the K8S cluster, so preserve files, maintain yaml formatting, and be careful what you change in the files. 
:::

### 6.2. Resource Configuration

Put a changes in the `dai-deploy_cr.yaml`, in each section, according to your previous estimations for the target product installation. 
Check in the example file [dai-deploy_cr.yaml](yamls/dai-deploy_cr-example.yaml) following sections: 
- `spec.centralConfiguration.resources` 
- `spec.master.resources` 
- `spec.worker.resources` 
- `spec.postgresql.resources` 
- `spec.rabbitmq.resources` 

The numbers in the example are not maybe what is required by your requirements.

### 6.3. Configuration file changes (optional)

If you don't have any customization in the configuration files (in the Deploy's conf or centralConfiguration directory), you can skip this section.

First check documentation how we manage the configuration files in the operator environment: 
[Customize Your Site—Custom Configuration of Deploy](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/operator/xl-op-deploy-customize.html)

In the documentation, it is described how to do changes if you have already had running Deploy on K8S cluster. 
During the migration we can do changes directly in the `dai-deploy_cr.yaml` file.

The changes from your on-prem configuration files need to go in the templates that you can get from the template directories. 
To get templates, you can run pods without running the central configuration, master or worker, for example, master configuration:
```shell
kubectl run master-01 -n digitalai --image=xebialabs/xl-deploy:23.3.2 --command -- /bin/bash -c "sleep infinity"
```
After that, you can get the templates from the master pod, similar to the documentation.

For any file that you would like to override in the configuration override its template:
1. Download the template
2. Change the file with custom changes
3. Put the file in the CR `dai-deploy_cr.yaml`, under 
  - `spec.centralConfiguration.extraConfiguration` section.
  - `spec.master.extraConfiguration` section.
  - `spec.worker.extraConfiguration` section.

Check the example file [dai-deploy_cr.yaml](yamls/dai-deploy_cr-example.yaml) under 
- `spec.centralConfiguration.extraConfiguration`
- `spec.master.extraConfiguration`
- `spec.worker.extraConfiguration`

sections, there are examples of how to customize:
- `central-conf/type-defaults.properties`
- `default-conf/deployit-security.xml`

In the same way, you can change any file in the configuration directory.

### 6.4. Other customizations (optional)

#### 6.4.1. Truststore

If you don't use truststore in your Deploy setup, you can skip this section.

Check the documentation how to set up it: [Set up Truststore for Deploy](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/operator/xl-op-deploy-setup-truststore.html).
Instead of applying the changes on the cluster use update the `dai-deploy_cr.yaml` file directly. 

#### 6.4.2. Set up JVM Arguments

If you need to set up some additional JVM arguments, check: [Set up JVM Arguments for Application Containers](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/operator/xl-op-deploy-setup-jvm-arguments.html).
Instead of applying the changes on the cluster use update the `dai-deploy_cr.yaml` file directly.

#### 6.4.3. Set up file logging

In the default setup the Deploy logging is not persisted to the filesystem, you can customize the configuration according to the examples:
- [Logging configuration scan & configuration values (not public, ask for the copy)](https://digitalai.atlassian.net/wiki/spaces/Labs/pages/77215137848/Logging+configuration+scan+configuration+values)
- [File logging with K8s operator (not public, ask for the copy)](https://digitalai.atlassian.net/wiki/spaces/Labs/pages/77215137976/File+logging+with+K8s+operator)

### 6.5. Test the Setup with Temporary Installation (optional)

If you would like, you can test the configuration before using existing or migrated data. 
The reason for this could to minimize downtime and to observe possible problems before using existing DB. 
In this section, we will start prepared configuration without any data so we can test that all is ok with our configuration changes.

#### 6.5.1 Change database configuration to temporary database

In case you are using an existing database, and you have already referenced it in the configuration; we need to change it to some other DB.
Create some temporary database, or delete the content of the database after this test:
- If you would like use the external **temporary** database: change the configuration to reference it from the section in the `dai-deploy_cr.yaml`: `spec.external.db`.
- If you would like to use the same external **empty** database, that same in the final installation: you will need to delete the content of the database after this test installation.
- If you have a configuration for PostgreSQL database that is part of the operator installation: you don't need to do anything.

#### 6.5.2. Apply temporary installation to cluster

```shell
xl kube install --files 20240108-120535
```

That command should apply all the files that are created by dry-run.

#### 6.5.3. Check the Test Installation

See section 7. to validate test installation. 

#### 6.5.4. Restore the Database Configuration

If you were using for tests external **temporary** database, restore the configuration in the `dai-deploy_cr.yaml` file under section `spec.external.db`.

If you were using for tests an external **empty** database, that is the same as in the final installation:
you will need to delete the content of the database after this test installation to restore migration data.

### 6.6. Restore Data to Target DB (optional)

If you are using an existing database from the previous installation, no need to do anything here, you are already set database configuration by setting external DB params during dry-run.

If the existing DB is not the same that you previously used in on-prem installation, be sure that you migrated the data to the new database, that is not part of this guide. 

In case you are using the PostgreSQL DB that is part of the Deploy operator installation, check this steps:

#### 6.6.1 Change replica count for master and worker

We need first to start the PostgreSQL that is part of the operator installation, but without master and worker running.
Change the replica count for master and worker, put to `0` values under:
- `spec.master.replicaCount`
- `spec.worker.replicaCount`

#### 6.6.2. Apply temporary installation to cluster

```shell
xl kube install --files 20240108-120535
```

That command should apply all the files that are created by dry-run and start PostgreSQL pod 
(and other pods Deploy operator, RabbitMQ, Central configuration, ingress if enabled). 

#### 6.6.3. Restore the Data

In this case, it is essential that Deploy master and worker were not connected to the database. 
Because restore will fail with errors about duplicate database entities.

For this step, you need to have already prepared dump that is compatible with PostgreSQL restore (check how to do backup in the step: 5.3.).
Be sure that the target directory on the pod exists (in the example we are using `/bitnami/postgresql/backup` that is mounted to have enough free space).

Execute the code to upload DB dump files to the PostgreSQL pod:
```shell
kubectl cp -c postgresql pg_dump-xld-db.sql.gzip digitalai/dai-xld-postgresql-0:/bitnami/postgresql/backup/pg_dump-xld-db.sql.gzip
# execute this if you have separate xld-report-db
kubectl cp -c postgresql pg_dump-xld-report-db.sql.gzip digitalai/dai-xld-postgresql-0:/bitnami/postgresql/backup/pg_dump-xld-report-db.sql.gzip
```

Connect to PostgreSQL pod console and restore the data to local DB:
```shell
gunzip -c /bitnami/postgresql/backup/pg_dump-xld-db.sql.gzip | psql -U xld xld-db
# execute this if you have separate xld-report-db
gunzip -c /bitnami/postgresql/backup/pg_dump-xld-report-db.sql.gzip | psql -U xld-report xld-report-db
```

:::note
Make sure that the directory on Pod where you are storing backup has enough free space.
:::

### 6.7. Apply the Setup on K8S Cluster

### 6.7.1 Review the `dai-deploy_cr.yaml`

Review the content of the `dai-deploy_cr.yaml`. 

Rollback temporary changes in case you have them:
- replica count from the 6.6.1 step;
- database configuration from the 6.5.1 step.

### 6.7.2 Apply final installation to cluster

If you have already resources created on the cluster, this step will update them.

```shell
xl kube install --files 20240108-120535
```

That command should apply all the files and start all Deploy pods on cluster.

## 7. Check the Installation

###  7.1 Check the resources

The following command will check and wait to Deploy resources (if they are not yet available on the cluster):

```shell
xl kube check
```

Command will fail if there are missing not-ready resources.

###  7.2 Check the connection

Check if Deploy master is working correctly by using port-forwarding to the master service (example for digitalai namespace):
```shell
kubectl port-forward -n digitalai svc/dai-xld-digitalai-deploy-lb 4516:4516
```
And open in a browser URL: http://localhost:4516/

Or check if ingress (or route) setup is working by opening the URL in a browser that you setup for ingress (or route).

## 8. Rollback

In case you are not satisfied with migration, you can go back to the on-prem setup: 

### 8.1. Clean Current Installation from K8S Cluster

```shell
xl kube clean
```

The command will clean all the resources from the cluster.

### 8.2. Start back on-prem Deploy

Use the already available installation on-prem Deploy to start it. 

## 9. Final Notes

To minimize downtime plan your migration, execute the following steps on the end:
- all the steps from section 5.
- and after that steps 6.6., 6.7.

Additional plugin management after migration can be done by using `xl plugin` commands, check 
[Manage Plugins in Kubernetes Environment](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/operator/xl-op-deploy-plugin-management.html)

If you need some additional customization of the Deploy installation, check [Update Parameters in the CR File or Deployment](https://docs.digital.ai/bundle/devops-deploy-version-v.23.3/page/deploy/operator/xl-op-deploy-apply-changes-from-custom-resource.html)
