# Repository Deprecated

⚠️ **This repository is no longer maintained.** ⚠️

Please use the [deploy-helm-chart](https://github.com/digital-ai/deploy-helm-chart) repository for the latest updates and support.


# Helm chart for Digital.ai Deploy

**From 10.2 version helm chart is not used directly. Use operator based installation instead.**

Additional documentation can be found by this link:
- https://digital.ai/products/deploy/
- https://docs.digital.ai/bundle/devops-deploy-version-v.24.1/page/deploy/operator/xl-op-before-you-begin.html
- https://digital-ai.github.io/deploy-helm-chart/

## Prerequisites

- Kubernetes 1.20+
- Helm 3.2.0+

## Minimal configuration for the K3D cluster

To install the chart with the release name `daid`:

```shell
helm dependency update .
helm install daid . -n digitalai  --create-namespace --values tests/values/basic.yaml
```

On finish of the last command you will see information about helm release.

### Minimal configuration for the AWS cluster

Run helm release `daid` installation with creation of the namespace:
```shell
helm dependency update .
helm install daid . -n digitalai --create-namespace --values tests/values/basic.yaml --values tests/values/aws.yaml
```

Note: The installation uses storageClass `my-efs`, change the name in the `tests/values/aws.yaml` if you need something else.

On finish of the last command you will see information about helm release.

### Minimal configuration for the OpenShift cluster (AWS)

Run helm release `daid` installation with creation of the namespace:
```shell
helm dependency update .
helm install daid . -n digitalai --create-namespace --values tests/values/basic.yaml --values tests/values/openshift-route.yaml
```

Note: The installation uses storageClass `gp2`, change the name in the `tests/values/aws.yaml` if you need something else.
The installation is setting the route hostname, change the value of the hostname for the specific setup on the cluster.

On finish of the last command you will see information about helm release.

## Uninstalling the Chart

To uninstall/delete the `daid` release:

```shell
helm delete daid -n digitalai
```
The command removes all the Kubernetes components associated with the chart and deletes the release.
Uninstalling the chart will not remove the PVCs, you need to delete them manually.

To delete all resources with one command you can delete namespace with:
```shell
kubectl delete namespace digitalai
```

## Parameters

### Global parameters

| Name                                         | Description                                                    | Value |
| -------------------------------------------- | -------------------------------------------------------------- | ----- |
| `global.imageRegistry`                       | Global Docker image registry                                   | `""`  |
| `global.imagePullSecrets`                    | Global Docker registry secret names as an array                | `[]`  |
| `global.storageClass`                        | Global StorageClass for Persistent Volume(s)                   | `""`  |
| `global.postgresql.service.ports.postgresql` | PostgreSQL service port (overrides `service.ports.postgresql`) | `""`  |

### K8S Env parameters

| Name                      | Description                                                                                      | Value      |
| ------------------------- | ------------------------------------------------------------------------------------------------ | ---------- |
| `k8sSetup.platform`       | The platform on which you install the chart. Possible values: AWSEKS/AzureAKS/GoogleGKE/PlainK8s | `PlainK8s` |
| `k8sSetup.validateValues` | Enable validation of the values                                                                  | `true`     |

### Deploy servers common parameters

| Name                    | Description                                                                                                                                                                                                            | Value   |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `license`               | Sets your XL License by passing a base64 string license, which will then be added to the license file.                                                                                                                 | `nil`   |
| `licenseAcceptEula`     | Accept EULA, in case of missing license, it will generate temporary license.                                                                                                                                           | `false` |
| `generateXlConfig`      | Generate configuration from environment parameters passed, and volumes mounted with custom changes. If set to false, a default config will be used and all environment variables and volumes added will be ignored.    | `true`  |
| `externalCentralConfig` | Flag to disable the embedded config server and use external config server. If "true", the embedded config server will be used and the external config server denoted by the "CENTRAL_CONFIG_URL" variable will be used | `true`  |
| `xldInProcess`          | Used to control whether the internal in-process worker should be used or not. If you need to use external workers then this needs to be set to false.                                                                  | `false` |
| `usaCache`              | Flag to disable/enable the use of application cache                                                                                                                                                                    | `false` |
| `appContextRoot`        | Deploy context root.                                                                                                                                                                                                   | `/`     |
| `clusterMode`           | This is to specify if the HA setup is needed and to specify the HA mode. Possible values: "default", "hot-standby", "full"                                                                                             | `full`  |

### Deploy external resources

| Name                             | Description                                                                          | Value     |
| -------------------------------- | ------------------------------------------------------------------------------------ | --------- |
| `external.db.enabled`            | Enable external database                                                             | `false`   |
| `external.db.main.url`           | Main database URL for Deploy                                                         | `""`      |
| `external.db.main.username`      | Main database username for Deploy                                                    | `nil`     |
| `external.db.main.password`      | Main database password for Deploy                                                    | `nil`     |
| `external.db.main.maxPoolSize`   | Main database max pool size for Deploy                                               | `""`      |
| `external.db.report.url`         | Report database URL for Deploy                                                       | `""`      |
| `external.db.report.username`    | Report database username for Deploy                                                  | `nil`     |
| `external.db.report.password`    | Report database password for Deploy                                                  | `nil`     |
| `external.db.report.maxPoolSize` | Report database max pool size for Deploy                                             | `""`      |
| `external.mq.enabled`            | Enable external message queue                                                        | `false`   |
| `external.mq.url`                | External message queue broker URL for Deploy                                         | `""`      |
| `external.mq.queueName`          | External message queue name for Deploy                                               | `""`      |
| `external.mq.username`           | External message queue broker username for Deploy                                    | `nil`     |
| `external.mq.password`           | External message queue broker password for Deploy                                    | `nil`     |
| `external.mq.driverClassName`    | External message queue driver class name for Deploy                                  | `""`      |
| `external.mq.queueType`          | Valid only for External rabbitmq message queue. Possible values: "quorum", "classic" | `classic` |

### Deploy keystore and truststore parameters

| Name                                 | Description                                                       | Value                                                                                                                                                                                                    |
| ------------------------------------ | ----------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `keystore.passphrase`                | Set passphrase for the keystore                                   | `nil`                                                                                                                                                                                                    |
| `keystore.keystore`                  | Use repository-keystore.jceks files content ecoded with base64    | `nil`                                                                                                                                                                                                    |
| `truststore.type`                    | Type of truststore, possible value jks or jceks or pkcs12         | `pkcs12`                                                                                                                                                                                                 |
| `truststore.password`                | Truststore password                                               | `nil`                                                                                                                                                                                                    |
| `truststore.truststore`              | Truststore file base64 encoded                                    | `{}`                                                                                                                                                                                                     |
| `truststore.params`                  | Truststore params in the command line                             | `{{- if .Values.truststore.truststore }} -Djavax.net.ssl.trustStore=$(TRUSTSTORE) -Djavax.net.ssl.trustStorePassword=$(TRUSTSTORE_PASSWORD) -Djavax.net.ssl.trustStoreType=$(TRUSTSTORE_TYPE){{- end }}` |
| `securityContextConstraints.enabled` | Enabled SecurityContextConstraints for Deploy (only on Openshift) | `true`                                                                                                                                                                                                   |

### Deploy hooks

| Name                                                                    | Description                                                                                                                  | Value                                                            |
| ----------------------------------------------------------------------- |------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------|
| `busyBox.image.registry`                                                | busyBox container image registry                                                                                             | `docker.io`                                                      |
| `busyBox.image.repository`                                              | busyBox container image repository                                                                                           | `library/busybox`                                                |
| `busyBox.image.tag`                                                     | busyBox container image tag                                                                                                  | `stable`                                                         |
| `busyBox.image.pullPolicy`                                              | busyBox container image pull policy                                                                                          | `IfNotPresent`                                                   |
| `busyBox.image.pullSecrets`                                             | Specify docker-registry secret names as an array                                                                             | `[]`                                                             |
| `hooks.getLicense.enabled`                                              | set to true to support license auto generation by using helm hook, it is working together with enabled licenseAcceptEula     | `true`                                                           |
| `hooks.getLicense.name`                                                 | Name of the resources that will be used during hook execution                                                                | `{{ include "common.names.fullname" . }}-license`                |
| `hooks.getLicense.deletePolicy`                                         | Helm hook delete policy                                                                                                      | `before-hook-creation,hook-succeeded`                            |
| `hooks.getLicense.getCommand`                                           | The command for getting temporary license, see hooks.getLicense.configuration.bin_get-license                                | `["/opt/xebialabs/xl-deploy-server/bin/get-license.sh"]`         |
| `hooks.getLicense.installCommand`                                       | The command for creating the secret with the license, see hooks.getLicense.configuration.bin_install-license                 | `["/opt/xebialabs/xl-deploy-server/bin/install-license.sh"]`     |
| `hooks.getLicense.image.registry`                                       | getLicense hook container image registry                                                                                     | `docker.io`                                                      |
| `hooks.getLicense.image.repository`                                     | getLicense hook container image repository                                                                                   | `bitnami/kubectl`                                                |
| `hooks.getLicense.image.tag`                                            | getLicense hook container image tag                                                                                          | `1.28.7-debian-12-r3`                                            |
| `hooks.getLicense.image.pullPolicy`                                     | getLicense hook container image pull policy                                                                                  | `IfNotPresent`                                                   |
| `hooks.getLicense.image.pullSecrets`                                    | Specify docker-registry secret names as an array                                                                             | `[]`                                                             |
| `hooks.getLicense.containerSecurityContext.enabled`                     | Enabled get licence containers' Security Context                                                                             | `true`                                                           |
| `hooks.getLicense.containerSecurityContext.runAsNonRoot`                | Set get licence container's Security Context runAsNonRoot                                                                    | `true`                                                           |
| `hooks.getLicense.containerSecurityContext.allowPrivilegeEscalation`    | Set get licence container's Security Context allowPrivilegeEscalation                                                        | `false`                                                          |
| `hooks.getLicense.containerSecurityContext.capabilities`                | Set get licence container's Security Context capabilities                                                                    |                                                                  |
| `hooks.getLicense.containerSecurityContext.seccompProfile`              | Set get licence container's Security Context seccompProfile                                                                  |                                                                  |
| `hooks.getLicense.configuration`                                        | Deploy Configuration file content                                                                                            |                                                                  |
| `hooks.getLicense.configuration.bin_get-license`                        | The configuration of the script for getting the license                                                                      |                                                                  |
| `hooks.getLicense.configuration.bin_get-license.path`                   | The path to the script for getting the license                                                                               | `bin/get-license.sh`                                             |
| `hooks.getLicense.configuration.bin_get-license.mode`                   | The access mode of the script for getting the license                                                                        | `755`                                                            |
| `hooks.getLicense.configuration.bin_get-license.content`                | Content of the script for getting the license                                                                                | _omitted too long default content_                               |
| `hooks.getLicense.configuration.bin_install-license`                    | The configuration of the script for setting up license secret                                                                |                                                                  |
| `hooks.getLicense.configuration.bin_install-license.path`               | The path to the script for setting up license secret                                                                         | `bin/install-license.sh`                                         |
| `hooks.getLicense.configuration.bin_install-license.mode`               | The access mode of the script for setting up license secret                                                                  | `755`                                                            |
| `hooks.getLicense.configuration.bin_install-license.content`            | Content of the script for setting up license secret                                                                          | _omitted too long default content_                               |
| `hooks.genSelfSigned.enabled`                                           | set to true to support self-signed ket auto generation by using helm hook                                                   | `false`                                                          |
| `hooks.genSelfSigned.name`                                              | Name of the resources that will be used during hook execution                                                               | `{{ include "common.names.fullname" . }}-self-signed`            |
| `hooks.genSelfSigned.deletePolicy`                                      | Helm hook delete policy                                                                                                     | `before-hook-creation,hook-succeeded`                            |
| `hooks.genSelfSigned.genCommand`                                        | The command for getting self-signed key, see hooks.genSelfSigned.configuration.bin_gen-self-signed                          | `["/opt/xebialabs/xl-deploy-server/bin/gen-self-signed.sh"]`     |
| `hooks.genSelfSigned.installCommand`                                    | The command for creating the secret with the self-signed key, see hooks.genSelfSigned.configuration.bin_install-self-signed | `["/opt/xebialabs/xl-deploy-server/bin/install-self-signed.sh"]` |
| `hooks.genSelfSigned.image.registry`                                    | genSelfSigned hook container image registry                                                                                 | `docker.io`                                                      |
| `hooks.genSelfSigned.image.repository`                                  | genSelfSigned hook container image repository                                                                               | `bitnami/kubectl`                                                |
| `hooks.genSelfSigned.image.tag`                                         | genSelfSigned hook container image tag                                                                                      | `1.28.7-debian-12-r3`                                            |
| `hooks.genSelfSigned.image.pullPolicy`                                  | genSelfSigned hook container image pull policy                                                                              | `IfNotPresent`                                                   |
| `hooks.genSelfSigned.image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                            | `[]`                                                             |
| `hooks.genSelfSigned.containerSecurityContext.enabled`                  | Enabled generate self-signed containers' Security Context                                                                   | `true`                                                           |
| `hooks.genSelfSigned.containerSecurityContext.runAsNonRoot`             | Set generate self-signed container's Security Context runAsNonRoot                                                          | `true`                                                           |
| `hooks.genSelfSigned.containerSecurityContext.allowPrivilegeEscalation` | Set generate self-signed container's Security Context allowPrivilegeEscalation                                              | `false`                                                          |
| `hooks.genSelfSigned.containerSecurityContext.capabilities`             | Set generate self-signed container's Security Context capabilities                                                          |                                                                  |
| `hooks.genSelfSigned.containerSecurityContext.seccompProfile`           | Set generate self-signed container's Security Context seccompProfile                                                        |                                                                  |
| `hooks.genSelfSigned.configuration`                                     | Deploy Configuration file content                                                                                           |                                                                  |
| `hooks.genSelfSigned.configuration.bin_gen-self-signed`                 | The configuration of the script for creating self signed key                                                                |                                                                  |
| `hooks.genSelfSigned.configuration.bin_gen-self-signed.path`            | The path to the script forcreating self signed key                                                                          | `bin/gen-self-signed.sh`                                         |
| `hooks.genSelfSigned.configuration.bin_gen-self-signed.mode`            | The access mode of the script for creating self signed key                                                                  | `755`                                                            |
| `hooks.genSelfSigned.configuration.bin_gen-self-signed.content`         | Content of the script for creating self signed key                                                                          | _omitted too long default content_                               |
| `hooks.genSelfSigned.configuration.bin_install-self-signed`             | The configuration of the script for setting up self-signed key secret                                                       |                                                                  |
| `hooks.genSelfSigned.configuration.bin_install-self-signed.path`        | The path to the script for setting up self-signed key secret                                                                | `bin/install-self-signed.sh`                                     |
| `hooks.genSelfSigned.configuration.bin_install-self-signed.mode`        | The access mode of the script for setting up self-signed key secret                                                         | `755`                                                            |
| `hooks.genSelfSigned.configuration.bin_install-self-signed.content`     | Content of the script for setting up self-signed key secret                                                                 | _omitted too long default content_                               |

### Deploy satellite parameters

| Name                | Description                                   | Value   |
| ------------------- | --------------------------------------------- | ------- |
| `satellite.enabled` | Enable support to work with Deploy Satellites | `false` |

### Deploy security parameters

| Name                                       | Description                                                                                                              | Value                                                                                                   |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------- |
| `auth.adminPassword`                       | Admin password for Deploy. If user does not provide password, random 10 character alphanumeric string will be generated. | `nil`                                                                                                   |
| `ssl.enabled`                              | Enable SSL to be used on Deploy                                                                                          | `false`                                                                                                 |
| `ssl.keystorePassword`                     | Keystore password with SSL key.                                                                                          | `changeme`                                                                                              |
| `ssl.keystoreKeypassword`                  | Keystore key password with SSL key.                                                                                      | `changeme`                                                                                              |
| `ssl.keystoreType`                         | Keystore type, options pkcs12 or jks.                                                                                    | `pkcs12`                                                                                                |
| `ssl.keystore`                             | Keystore content in base64 format or it can reference the existing secret.                                               |                                                                                                         |
| `ssl.keystore.valueFrom.secretKeyRef.name` | Name of the secret where the keystore was stored.                                                                        | `{{ include "common.tplvalues.render" ( dict "value" .Values.hooks.genSelfSigned.name "context" $ ) }}` |
| `ssl.keystore.valueFrom.secretKeyRef.key`  | Name of the key in the secret where the keystore was stored.                                                             | `keystore.{{ .Values.ssl.keystoreType }}`                                                               |

### Deploy Central Configuration parameters

| Name                                                 | Description                                                                             | Value   |
| ---------------------------------------------------- | --------------------------------------------------------------------------------------- | ------- |
| `centralConfiguration.overrideName`                  | If set the template will override the STS name.                                         | `""`    |
| `centralConfiguration.useIpAsHostname`               | Set IP address of the container as the hostname for the instance.                       | `false` |
| `centralConfiguration.terminationGracePeriodSeconds` | Default duration in seconds k8s waits for container to exit before sending kill signal. | `10`    |
| `centralConfiguration.encryptKey`                    | spring cloud config encryption key                                                      | `nil`   |
| `centralConfiguration.migrateFromEmbedded`           | Migrate to central configuration seprate server based setup                             | `false` |
| `centralConfiguration.replicaCount`                  | Number of deploy replicas to deploy                                                     | `1`     |

### deploy Central Configuration Image parameters

| Name                                     | Description                                       | Value                                        |
| ---------------------------------------- | ------------------------------------------------- | -------------------------------------------- |
| `centralConfiguration.image.registry`    | deploy image registry                             | `docker.io`                                  |
| `centralConfiguration.image.repository`  | deploy image repository                           | `xebialabsunsupported/central-configuration` |
| `centralConfiguration.image.tag`         | deploy image tag (immutable tags are recommended) | `{{ .Chart.AppVersion }}`                    |
| `centralConfiguration.image.pullPolicy`  | deploy image pull policy                          | `IfNotPresent`                               |
| `centralConfiguration.image.pullSecrets` | Specify docker-registry secret names as an array  | `[]`                                         |

### Central Configuration debug parameters

| Name                                             | Description                                                                                   | Value                                                                                                                                     |
| ------------------------------------------------ | --------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `centralConfiguration.diagnosticMode.enabled`    | Enable diagnostic mode (all probes will be disabled and the command will be overridden)       | `false`                                                                                                                                   |
| `centralConfiguration.diagnosticMode.command`    | Command to override all containers in the deployment                                          | `["/opt/xebialabs/tini"]`                                                                                                                 |
| `centralConfiguration.diagnosticMode.args`       | Args to override all containers in the deployment                                             | `["--","sleep","infinity"]`                                                                                                               |
| `centralConfiguration.debugMode.enabled`         | Enable debug mode (it starts all process with debug agent)                                    | `false`                                                                                                                                   |
| `centralConfiguration.debugMode.remoteJvmParams` | Agent lib configuration line with port. Do port forwarding to the port you would like to use. | `{{- if .Values.centralConfiguration.debugMode.enabled }} -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8001{{- end }}` |

### Central configuration DNS parameters

| Name                               | Description                 | Value |
| ---------------------------------- | --------------------------- | ----- |
| `centralConfiguration.hostAliases` | Deployment pod host aliases | `[]`  |
| `centralConfiguration.dnsPolicy`   | DNS Policy for pod          | `""`  |
| `centralConfiguration.dnsConfig`   | DNS Configuration pod       | `{}`  |

### Central configuration resource parameters

| Name                                      | Description                                   | Value |
| ----------------------------------------- | --------------------------------------------- | ----- |
| `centralConfiguration.resources.limits`   | The resources limits for deploy containers    | `{}`  |
| `centralConfiguration.resources.requests` | The requested resources for deploy containers | `{}`  |

### Central configuration Statefulset parameters

| Name                                                                     | Description                                                                                                              | Value                  |
| ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------ | ---------------------- |
| `centralConfiguration.health.enabled`                                    | Enable probes                                                                                                            | `true`                 |
| `centralConfiguration.health.periodScans`                                | Period seconds for probe                                                                                                 | `10`                   |
| `centralConfiguration.health.probeFailureThreshold`                      | Failure threshold for probe                                                                                              | `12`                   |
| `centralConfiguration.health.probesLivenessTimeout`                      | Initial delay seconds for livenessProbe                                                                                  | `20`                   |
| `centralConfiguration.health.probesReadinessTimeout`                     | Initial delay seconds for readinessProbe                                                                                 | `20`                   |
| `centralConfiguration.schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                | `""`                   |
| `centralConfiguration.podManagementPolicy`                               | Pod management policy                                                                                                    | `OrderedReady`         |
| `centralConfiguration.podLabels`                                         | deploy Pod labels. Evaluated as a template                                                                               |                        |
| `centralConfiguration.podLabels.app.kubernetes.io/component`             | Label with component name                                                                                                | `centralConfiguration` |
| `centralConfiguration.podAnnotations`                                    | deploy Pod annotations. Evaluated as a template                                                                          | `{}`                   |
| `centralConfiguration.updateStrategy.type`                               | Update strategy type for deploy statefulset                                                                              | `RollingUpdate`        |
| `centralConfiguration.statefulsetLabels`                                 | deploy statefulset labels. Evaluated as a template                                                                       |                        |
| `centralConfiguration.statefulsetLabels.app.kubernetes.io/component`     | Label with component name                                                                                                | `centralConfiguration` |
| `centralConfiguration.statefulsetAnnotations`                            | Deploy central configuration statefulset annotations. Evaluated as a template                                            | `{}`                   |
| `centralConfiguration.priorityClassName`                                 | Name of the priority class to be used by deploy pods, priority class needs to be created beforehand                      | `""`                   |
| `centralConfiguration.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `""`                   |
| `centralConfiguration.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`                 |
| `centralConfiguration.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`                   |
| `centralConfiguration.nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                    | `""`                   |
| `centralConfiguration.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                | `[]`                   |
| `centralConfiguration.affinity`                                          | Affinity for pod assignment. Evaluated as a template                                                                     | `{}`                   |
| `centralConfiguration.nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template                                                                  | `{}`                   |
| `centralConfiguration.tolerations`                                       | Tolerations for pod assignment. Evaluated as a template                                                                  | `[]`                   |
| `centralConfiguration.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`                   |
| `centralConfiguration.podSecurityContext.enabled`                        | Enable deploy pods' Security Context                                                                                     | `true`                 |
| `centralConfiguration.podSecurityContext.runAsUser`                      | Set Deploy pod's Security Context runAsUser                                                                              | `10001`                |
| `centralConfiguration.podSecurityContext.fsGroup`                        | Set deploy pod's Security Context fsGroup                                                                                | `10001`                |
| `centralConfiguration.containerSecurityContext.enabled`                  | Enabled deploy containers' Security Context                                                                              | `true`                 |
| `centralConfiguration.containerSecurityContext.runAsNonRoot`             | Set deploy container's Security Context runAsNonRoot                                                                     | `true`                 |
| `centralConfiguration.containerSecurityContext.allowPrivilegeEscalation` | Set deploy container's Security Context allowPrivilegeEscalation                                                         | `false`                |
| `centralConfiguration.containerSecurityContext.capabilities`             | Set deploy container's Security Context capabilities                                                                     |                        |
| `centralConfiguration.containerSecurityContext.seccompProfile`           | Set deploy container's Security Context seccompProfile                                                                   |                        |
| `centralConfiguration.initContainers`                                    | Add init containers to the deploy pod                                                                                    | `[]`                   |
| `centralConfiguration.sidecars`                                          | Add sidecar containers to the deploy pod                                                                                 | `[]`                   |

### Central Configuration Init Container parameters

| Name                                                                             | Description                                                                                                                       | Value                               |
| -------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |-------------------------------------|
| `centralConfiguration.volumePermissions.enabled`                                 | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup`              | `false`                             |
| `centralConfiguration.volumePermissions.image.registry`                          | Init container volume-permissions image registry                                                                                  | `docker.io`                         |
| `centralConfiguration.volumePermissions.image.repository`                        | Init container volume-permissions image repository                                                                                | `bitnami/os-shell`                  |
| `centralConfiguration.volumePermissions.image.tag`                               | Init container volume-permissions image tag                                                                                       | `12-debian-12-r16`                  |
| `centralConfiguration.volumePermissions.image.digest`                            | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                                |
| `centralConfiguration.volumePermissions.image.pullPolicy`                        | Init container volume-permissions image pull policy                                                                               | `IfNotPresent`                      |
| `centralConfiguration.volumePermissions.image.pullSecrets`                       | Specify docker-registry secret names as an array                                                                                  | `[]`                                |
| `centralConfiguration.volumePermissions.script`                                  | Script for changing the owner and group of the persistent volume(s). Paths are declared in the 'paths' variable.                  | _omitted too long default content_  |
| `centralConfiguration.volumePermissions.resources.limits`                        | Init container volume-permissions resource limits                                                                                 | `{}`                                |
| `centralConfiguration.volumePermissions.resources.requests`                      | Init container volume-permissions resource requests                                                                               | `{}`                                |
| `centralConfiguration.volumePermissions.containerSecurityContext.runAsUser`      | User ID for the init container                                                                                                    | `0`                                 |
| `centralConfiguration.volumePermissions.containerSecurityContext.runAsGroup`     | Group ID for the init container                                                                                                   | `0`                                 |
| `centralConfiguration.volumePermissions.containerSecurityContext.runAsNonRoot`   | Set volume permissions init container's Security Context runAsNonRoot                                                             | `false`                             |
| `centralConfiguration.volumePermissions.containerSecurityContext.seccompProfile` | Set volume permissions init container's Security Context seccompProfile                                                           |                                     |

### Central Configuration Pod Disruption Budget configuration

| Name                                      | Description                                                    | Value   |
| ----------------------------------------- | -------------------------------------------------------------- | ------- |
| `centralConfiguration.pdb.create`         | Enable/disable a Pod Disruption Budget creation                | `false` |
| `centralConfiguration.pdb.minAvailable`   | Minimum number/percentage of pods that should remain scheduled | `1`     |
| `centralConfiguration.pdb.maxUnavailable` | Maximum number/percentage of pods that may be made unavailable | `""`    |

### Central Configuration Persistence parameters

| Name                                                                   | Description                                      | Value               |
| ---------------------------------------------------------------------- | ------------------------------------------------ | ------------------- |
| `centralConfiguration.persistence.enabled`                             | Enable deploy data persistence using PVC         | `false`             |
| `centralConfiguration.persistence.single`                              | Enable deploy data to use single PVC             | `false`             |
| `centralConfiguration.persistence.storageClass`                        | PVC Storage Class for deploy data volume         | `""`                |
| `centralConfiguration.persistence.selector`                            | Selector to match an existing Persistent Volume  | `{}`                |
| `centralConfiguration.persistence.accessModes`                         | PVC Access Modes for deploy data volume          | `["ReadWriteOnce"]` |
| `centralConfiguration.persistence.existingClaim`                       | Provide an existing PersistentVolumeClaims       | `""`                |
| `centralConfiguration.persistence.size`                                | PVC Storage Request for deploy data volume       | `1Gi`               |
| `centralConfiguration.persistence.annotations`                         | Persistence annotations. Evaluated as a template |                     |
| `centralConfiguration.persistence.annotations.helm.sh/resource-policy` | Persistence annotation for keeping created PVCs  | `keep`              |
| `centralConfiguration.persistence.paths`                               | mounted paths for the Deploy master              | `[]`                |

### Central Configuration Deploy runtime parameters

| Name                                                                                  | Description                                                                                       | Value                                                                                                   |
| ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |---------------------------------------------------------------------------------------------------------|
| `centralConfiguration.jvmArgs`                                                        | Deploy centralConfiguration JVM arguments                                                         | `""`                                                                                                    |
| `centralConfiguration.command`                                                        | Override default container command (useful when using custom images)                              | `["/opt/xebialabs/tini"]`                                                                               |
| `centralConfiguration.args`                                                           | Override default container args (useful when using custom images)                                 | `["--","/opt/xebialabs/central-configuration-server/bin/run-in-operator.sh"]`                           |
| `centralConfiguration.lifecycleHooks`                                                 | Overwrite livecycle for the deploy container(s) to automate configuration before or after startup | `{}`                                                                                                    |
| `centralConfiguration.ssl`                                                            | This section exists as placeholder, but the CC HTTPS is not yet supported.                        |                                                                                                         |
| `centralConfiguration.ssl.enabled`                                                    | Enable SSL to be used on Deploy                                                                   | `false`                                                                                                 |
| `centralConfiguration.ssl.keystorePassword`                                           | Keystore password with SSL key.                                                                   | `changeme`                                                                                              |
| `centralConfiguration.ssl.keystoreKeypassword`                                        | Keystore key password with SSL key.                                                               | `changeme`                                                                                              |
| `centralConfiguration.ssl.keystoreType`                                               | Keystore type, options pkcs12 or jks.                                                             | `pkcs12`                                                                                                |
| `centralConfiguration.ssl.keystore`                                                   | Keystore content in base64 format or it can reference the existing secret.                        |                                                                                                         |
| `centralConfiguration.ssl.keystore.valueFrom.secretKeyRef.name`                       | Name of the secret where the keystore was stored.                                                 | `{{ include "common.tplvalues.render" ( dict "value" .Values.hooks.genSelfSigned.name "context" $ ) }}` |
| `centralConfiguration.ssl.keystore.valueFrom.secretKeyRef.key`                        | Name of the key in the secret where the keystore was stored.                                      | `keystore.{{ .Values.ssl.keystoreType }}`                                                               |
| `centralConfiguration.logback.globalLoggingLevel`                                     | Global logging level. Possible values: "trace", "debug", "info", "warn", "error".                 | `info`                                                                                                  |
| `centralConfiguration.logback.scanEnabled`                                            | Enables scanning of logback.xml.                                                                  | `true`                                                                                                  |
| `centralConfiguration.logback.scanPeriod`                                             | Interval for checking logback.xml configuration.                                                  | `30 seconds`                                                                                            |
| `centralConfiguration.extraEnvVars`                                                   | Extra environment variables to add to deploy pods                                                 | `[]`                                                                                                    |
| `centralConfiguration.extraEnvVarsCM`                                                 | Name of existing ConfigMap containing extra environment variables                                 | `""`                                                                                                    |
| `centralConfiguration.extraEnvVarsSecret`                                             | Name of existing Secret containing extra environment variables (in case of sensitive data)        | `""`                                                                                                    |
| `centralConfiguration.containerPorts.ccHttp`                                          | Deploy central configuration HTTP port value exposed on the central configuration container       | `8888`                                                                                                  |
| `centralConfiguration.containerPorts.ccHttps`                                         | Deploy central configuration HTTPS port value exposed on the central configuration container      | `8843`                                                                                                  |
| `centralConfiguration.extraContainerPorts`                                            | Extra ports to be included in container spec, primarily informational                             | `[]`                                                                                                    |
| `centralConfiguration.configuration`                                                  | deploy Configuration file content: required cluster configuration                                 |                                                                                                         |
| `centralConfiguration.configuration.bin_run-in-operator-sh`                           | The script for starting the central configuration with K8S configuration                          |                                                                                                         |
| `centralConfiguration.configuration.bin_run-in-operator-sh.path`                      | The path for the script for starting the central configuration with K8S configuration             | `bin/run-in-operator.sh`                                                                                |
| `centralConfiguration.configuration.bin_run-in-operator-sh.mode`                      | The access mode for the script for starting the central configuration with K8S configuration      | `755`                                                                                                   |
| `centralConfiguration.configuration.bin_run-in-operator-sh.content`                   | Content of the script for starting the central configuration with K8S configuration               | _omitted too long default content_                                                                      |
| `centralConfiguration.configuration.central-conf_deploy-server-yaml-template`         | The configuration file deploy-server.yaml.template                                                |                                                                                                         |
| `centralConfiguration.configuration.central-conf_deploy-server-yaml-template.path`    | The path to the configuration file deploy-server.yaml.template                                    | `central-conf/deploy-server.yaml.template`                                                              |
| `centralConfiguration.configuration.central-conf_deploy-server-yaml-template.mode`    | The access mode for the configuration file deploy-server.yaml.template                            | `660`                                                                                                   |
| `centralConfiguration.configuration.central-conf_deploy-server-yaml-template.content` | Content of the configuration file deploy-server.yaml.template                                     | _omitted too long default content_                                                                      |
| `centralConfiguration.configuration.central-conf_deploy-oidc-yaml-template`           | The configuration file deploy-oidc.yaml.template                                                  |                                                                                                         |
| `centralConfiguration.configuration.central-conf_deploy-oidc-yaml-template.path`      | The path to the configuration file deploy-oidc.yaml.template                                      | `central-conf/deploy-oidc.yaml.template`                                                                |
| `centralConfiguration.configuration.central-conf_deploy-oidc-yaml-template.mode`      | The access mode for the configuration file deploy-oidc.yaml.template                              | `660`                                                                                                   |
| `centralConfiguration.configuration.central-conf_deploy-oidc-yaml-template.content`   | Content of the configuration file deploy-oidc.yaml.template                                       | _omitted too long default content_                                                                      |
| `centralConfiguration.extraConfiguration`                                             | Configuration file content: extra configuration to be appended to deploy configuration            | `{}`                                                                                                    |
| `centralConfiguration.extraVolumeMounts`                                              | Optionally specify extra list of additional volumeMounts                                          | `[]`                                                                                                    |
| `centralConfiguration.extraVolumes`                                                   | Optionally specify extra list of additional volumes .                                             | `[]`                                                                                                    |
| `centralConfiguration.extraSecrets`                                                   | Optionally specify extra secrets to be created by the chart.                                      | `{}`                                                                                                    |
| `centralConfiguration.extraSecretsPrependReleaseName`                                 | Set this flag to true if extraSecrets should be created with <release-name> prepended.            | `false`                                                                                                 |

### Central Configuration Exposure parameters

| Name                                                              | Description                                                                                                               | Value                  |
| ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `centralConfiguration.service.type`                               | Kubernetes Service type                                                                                                   | `ClusterIP`            |
| `centralConfiguration.service.portEnabled`                        | deploy port. Cannot be disabled when `auth.tls.enabled` is `false`. Listener can be disabled with `listeners.tcp = none`. | `true`                 |
| `centralConfiguration.service.ports.ccHttp`                       | Deploy central configuration service HTTP port value                                                                      | `8888`                 |
| `centralConfiguration.service.ports.ccHttps`                      | Deploy central configuration service HTTPS port value                                                                     | `8843`                 |
| `centralConfiguration.service.portNames.ccHttp`                   | Deploy central configuration HTTP port name                                                                               | `deploy-http-cc`       |
| `centralConfiguration.service.portNames.ccHttps`                  | Deploy central configuration HTTPS port name                                                                              | `deploy-https-cc`      |
| `centralConfiguration.service.nodePorts.ccHttp`                   | Deploy central configuration HTTP port value exposed on the node (in case of NodePort service)                            | `""`                   |
| `centralConfiguration.service.nodePorts.ccHttps`                  | Deploy central configuration HTTPS port value exposed on the node (in case of NodePort service)                           | `""`                   |
| `centralConfiguration.service.extraPorts`                         | Extra ports to expose in the service                                                                                      | `[]`                   |
| `centralConfiguration.service.loadBalancerSourceRanges`           | Address(es) that are allowed when service is `LoadBalancer`                                                               | `[]`                   |
| `centralConfiguration.service.externalIPs`                        | Set the ExternalIPs                                                                                                       | `[]`                   |
| `centralConfiguration.service.externalTrafficPolicy`              | Enable client source IP preservation                                                                                      | `Cluster`              |
| `centralConfiguration.service.loadBalancerIP`                     | Set the LoadBalancerIP                                                                                                    | `""`                   |
| `centralConfiguration.service.clusterIP`                          | Kubernetes service Cluster IP                                                                                             | `""`                   |
| `centralConfiguration.service.labels`                             | Service labels. Evaluated as a template                                                                                   |                        |
| `centralConfiguration.service.labels.app.kubernetes.io/component` | Label with component name                                                                                                 | `centralConfiguration` |
| `centralConfiguration.service.annotations`                        | Service annotations. Evaluated as a template                                                                              | `{}`                   |
| `centralConfiguration.service.sessionAffinity`                    | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                      | `None`                 |
| `centralConfiguration.service.sessionAffinityConfig`              | Additional settings for the sessionAffinity                                                                               | `{}`                   |

### Deploy master parameters

| Name                                   | Description                                                                                                            | Value                                                                                               |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| `master.overrideName`                  | If set the template will override the STS name.                                                                        | `""`                                                                                                |
| `master.useIpAsHostname`               | Set IP address of the container as the hostname for the instance.                                                      | `false`                                                                                             |
| `master.clusterNodeHostnameSuffix`     | If set the template will override the hostname.                                                                        | `.{{ include "deploy.names.master" $ }}.{{ include "common.names.namespace" . }}.svc.cluster.local` |
| `master.terminationGracePeriodSeconds` | Default duration in seconds k8s waits for container to exit before sending kill signal.                                | `90`                                                                                                |
| `master.forceUpgrade`                  | It can be used to perform an upgrade in non-interactive mode by passing flag -force-upgrades while starting a service. | `true`                                                                                              |
| `master.replicaCount`                  | Number of deploy master replicas to deploy                                                                             | `3`                                                                                                 |

### Deploy Master Image parameters

| Name                       | Description                                              | Value                            |
| -------------------------- | -------------------------------------------------------- | -------------------------------- |
| `master.image.registry`    | deploy master image registry                             | `docker.io`                      |
| `master.image.repository`  | deploy master image repository                           | `xebialabsunsupported/xl-deploy` |
| `master.image.tag`         | deploy master image tag (immutable tags are recommended) | `{{ .Chart.AppVersion }}`        |
| `master.image.pullPolicy`  | deploy master image pull policy                          | `IfNotPresent`                   |
| `master.image.pullSecrets` | Specify docker-registry secret names as an array         | `[]`                             |

### Master debug parameters

| Name                               | Description                                                                                   | Value                                                                                                                       |
| ---------------------------------- | --------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `master.diagnosticMode.enabled`    | Enable diagnostic mode (all probes will be disabled and the command will be overridden)       | `false`                                                                                                                     |
| `master.diagnosticMode.command`    | Command to override all containers in the deployment                                          | `["/opt/xebialabs/tini"]`                                                                                                   |
| `master.diagnosticMode.args`       | Args to override all containers in the deployment                                             | `["--","sleep","infinity"]`                                                                                                 |
| `master.debugMode.enabled`         | Enable debug mode (it starts all process with debug agent)                                    | `false`                                                                                                                     |
| `master.debugMode.remoteJvmParams` | Agent lib configuration line with port. Do port forwarding to the port you would like to use. | `{{- if .Values.master.debugMode.enabled }} -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8001{{- end }}` |

### Master DNS parameters

| Name                 | Description                 | Value |
| -------------------- | --------------------------- | ----- |
| `master.hostAliases` | Deployment pod host aliases | `[]`  |
| `master.dnsPolicy`   | DNS Policy for pod          | `""`  |
| `master.dnsConfig`   | DNS Configuration pod       | `{}`  |

### Master resource parameters

| Name                        | Description                                   | Value |
| --------------------------- | --------------------------------------------- | ----- |
| `master.resources.limits`   | The resources limits for deploy containers    | `{}`  |
| `master.resources.requests` | The requested resources for deploy containers | `{}`  |

### Master Statefulset parameters

| Name                                                       | Description                                                                                                              | Value          |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | -------------- |
| `master.health.enabled`                                    | Enable probes                                                                                                            | `true`         |
| `master.health.periodScans`                                | Period seconds for probe                                                                                                 | `10`           |
| `master.health.probeFailureThreshold`                      | Failure threshold for probe                                                                                              | `12`           |
| `master.health.probesLivenessTimeout`                      | Initial delay seconds for livenessProbe                                                                                  | `60`           |
| `master.health.probesReadinessTimeout`                     | Initial delay seconds for readinessProbe                                                                                 | `60`           |
| `master.schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                | `""`           |
| `master.podManagementPolicy`                               | Pod management policy                                                                                                    | `OrderedReady` |
| `master.podLabels`                                         | deploy Pod labels. Evaluated as a template                                                                               |                |
| `master.podLabels.app.kubernetes.io/component`             | Label with component name                                                                                                | `master`       |
| `master.podAnnotations`                                    | deploy Pod annotations. Evaluated as a template                                                                          | `{}`           |
| `master.updateStrategy.type`                               | Update strategy type for deploy statefulset                                                                              | `OnDelete`     |
| `master.statefulsetLabels`                                 | deploy statefulset labels. Evaluated as a template                                                                       |                |
| `master.statefulsetLabels.app.kubernetes.io/component`     | Label with component name                                                                                                | `master`       |
| `master.statefulsetAnnotations`                            | Deploy cmaster statefulset annotations. Evaluated as a template                                                          | `{}`           |
| `master.priorityClassName`                                 | Name of the priority class to be used by deploy pods, priority class needs to be created beforehand                      | `""`           |
| `master.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `""`           |
| `master.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`         |
| `master.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`           |
| `master.nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                    | `""`           |
| `master.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                | `[]`           |
| `master.affinity`                                          | Affinity for pod assignment. Evaluated as a template                                                                     | `{}`           |
| `master.nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template                                                                  | `{}`           |
| `master.tolerations`                                       | Tolerations for pod assignment. Evaluated as a template                                                                  | `[]`           |
| `master.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`           |
| `master.podSecurityContext.enabled`                        | Enable deploy pods' Security Context                                                                                     | `true`         |
| `master.podSecurityContext.runAsUser`                      | Set Deploy pod's Security Context runAsUser                                                                              | `10001`        |
| `master.podSecurityContext.fsGroup`                        | Set deploy pod's Security Context fsGroup                                                                                | `10001`        |
| `master.containerSecurityContext.enabled`                  | Enabled deploy containers' Security Context                                                                              | `true`         |
| `master.containerSecurityContext.runAsNonRoot`             | Set deploy container's Security Context runAsNonRoot                                                                     | `true`         |
| `master.containerSecurityContext.allowPrivilegeEscalation` | Set deploy container's Security Context allowPrivilegeEscalation                                                         | `false`        |
| `master.containerSecurityContext.capabilities`             | Set deploy container's Security Context capabilities                                                                     |                |
| `master.containerSecurityContext.seccompProfile`           | Set deploy container's Security Context seccompProfile                                                                   |                |
| `master.initContainers`                                    | Add init containers to the deploy master pod                                                                             | `[]`           |
| `master.sidecars`                                          | Add sidecar containers to the deploy master pod                                                                          | `[]`           |

### Master Init Container parameters

| Name                                                               | Description                                                                                                                       | Value                               |
| ------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- |-------------------------------------|
| `master.volumePermissions.enabled`                                 | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup`              | `false`                             |
| `master.volumePermissions.image.registry`                          | Init container volume-permissions image registry                                                                                  | `docker.io`                         |
| `master.volumePermissions.image.repository`                        | Init container volume-permissions image repository                                                                                | `bitnami/os-shell`                  |
| `master.volumePermissions.image.tag`                               | Init container volume-permissions image tag                                                                                       | `12-debian-12-r16`                  |
| `master.volumePermissions.image.digest`                            | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                                |
| `master.volumePermissions.image.pullPolicy`                        | Init container volume-permissions image pull policy                                                                               | `IfNotPresent`                      |
| `master.volumePermissions.image.pullSecrets`                       | Specify docker-registry secret names as an array                                                                                  | `[]`                                |
| `master.volumePermissions.script`                                  | Script for changing the owner and group of the persistent volume(s). Paths are declared in the 'paths' variable.                  | _omitted too long default content_  |
| `master.volumePermissions.resources.limits`                        | Init container volume-permissions resource limits                                                                                 | `{}`                                |
| `master.volumePermissions.resources.requests`                      | Init container volume-permissions resource requests                                                                               | `{}`                                |
| `master.volumePermissions.containerSecurityContext.runAsUser`      | User ID for the init container                                                                                                    | `0`                                 |
| `master.volumePermissions.containerSecurityContext.runAsGroup`     | Group ID for the init container                                                                                                   | `0`                                 |
| `master.volumePermissions.containerSecurityContext.runAsNonRoot`   | Set volume permissions init container's Security Context runAsNonRoot                                                             | `false`                             |
| `master.volumePermissions.containerSecurityContext.seccompProfile` | Set volume permissions init container's Security Context seccompProfile                                                           |                                     |

### Master Pod Disruption Budget configuration

| Name                        | Description                                                    | Value   |
| --------------------------- | -------------------------------------------------------------- | ------- |
| `master.pdb.create`         | Enable/disable a Pod Disruption Budget creation                | `false` |
| `master.pdb.minAvailable`   | Minimum number/percentage of pods that should remain scheduled | `1`     |
| `master.pdb.maxUnavailable` | Maximum number/percentage of pods that may be made unavailable | `""`    |

### Master Persistence parameters

| Name                                                     | Description                                      | Value                                      |
| -------------------------------------------------------- | ------------------------------------------------ | ------------------------------------------ |
| `master.persistence.enabled`                             | Enable deploy data persistence using PVC         | `true`                                     |
| `master.persistence.single`                              | Enable deploy data to use single PVC             | `false`                                    |
| `master.persistence.storageClass`                        | PVC Storage Class for deploy data volume         | `""`                                       |
| `master.persistence.selector`                            | Selector to match an existing Persistent Volume  | `{}`                                       |
| `master.persistence.accessModes`                         | PVC Access Modes for deploy data volume          | `["ReadWriteOnce"]`                        |
| `master.persistence.existingClaim`                       | Provide an existing PersistentVolumeClaims       | `""`                                       |
| `master.persistence.size`                                | PVC Storage Request for deploy data volume       | `8Gi`                                      |
| `master.persistence.annotations`                         | Persistence annotations. Evaluated as a template |                                            |
| `master.persistence.annotations.helm.sh/resource-policy` | Persistence annotation for keeping created PVCs  | `keep`                                     |
| `master.persistence.paths`                               | mounted paths for the Deploy master              | `["/opt/xebialabs/xl-deploy-server/work"]` |

### Master runtime parameters

| Name                                                  | Description                                                                                       | Value                                                             |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------- |-------------------------------------------------------------------|
| `master.jvmArgs`                                      | Deploy master JVM arguments                                                                       | `""`                                                              |
| `master.command`                                      | Override default container command (useful when using custom images)                              | `["/opt/xebialabs/tini"]`                                         |
| `master.args`                                         | Override default container args (useful when using custom images)                                 | `["--","/opt/xebialabs/xl-deploy-server/bin/run-in-operator.sh"]` |
| `master.lifecycleHooks`                               | Overwrite livecycle for the deploy container(s) to automate configuration before or after startup | `{}`                                                              |
| `master.logback.globalLoggingLevel`                   | Global logging level. Possible values: "trace", "debug", "info", "warn", "error".                 | `info`                                                            |
| `master.logback.scanEnabled`                          | Enables scanning of logback.xml.                                                                  | `true`                                                            |
| `master.logback.scanPeriod`                           | Interval for checking logback.xml configuration.                                                  | `30 seconds`                                                      |
| `master.extraEnvVars`                                 | Extra environment variables to add to deploy pods                                                 | `[]`                                                              |
| `master.extraEnvVarsCM`                               | Name of existing ConfigMap containing extra environment variables                                 | `""`                                                              |
| `master.extraEnvVarsSecret`                           | Name of existing Secret containing extra environment variables (in case of sensitive data)        | `""`                                                              |
| `master.containerPorts.deployHttp`                    | Deploy HTTP port value exposed on the master container                                            | `4516`                                                            |
| `master.containerPorts.deployHttps`                   | Deploy HTTPS port value exposed on the master container                                           | `4517`                                                            |
| `master.containerPorts.deployPekko`                   | Deploy Pekko port value exposed on the master container                                           | `8180`                                                            |
| `master.containerPorts.deployClusterPekko`            | Deploy Pekko cluster port value exposed on the master container                                   | `25520`                                                           |
| `master.containerPorts.deployJmxExporter`             | Deploy JMX exporter port value exposed on the master container                                    | `9100`                                                            |
| `master.extraContainerPorts`                          | Extra ports to be included in container spec, primarily informational                             | `[]`                                                              |
| `master.configuration`                                | Deploy Configuration file content: required cluster configuration                                 |                                                                   |
| `master.configuration.bin_run-in-operator-sh`         | The script for starting the master with K8S configuration                                         |                                                                   |
| `master.configuration.bin_run-in-operator-sh.path`    | The path for the script for starting the master with K8S configuration                            | `bin/run-in-operator.sh`                                          |
| `master.configuration.bin_run-in-operator-sh.mode`    | The access mode for the script for starting the master with K8S configuration                     | `755`                                                             |
| `master.configuration.bin_run-in-operator-sh.content` | Content of the script for starting the master with K8S configuration                              | _omitted too long default content_                                |
| `master.extraConfiguration`                           | Configuration file content: extra configuration to be appended to deploy configuration            | `{}`                                                              |
| `master.extraVolumeMounts`                            | Optionally specify extra list of additional volumeMounts                                          | `[]`                                                              |
| `master.extraVolumes`                                 | Optionally specify extra list of additional volumes .                                             | `[]`                                                              |
| `master.extraSecrets`                                 | Optionally specify extra secrets to be created by the chart.                                      | `{}`                                                              |
| `master.extraSecretsPrependReleaseName`               | Set this flag to true if extraSecrets should be created with <release-name> prepended.            | `false`                                                           |

### Master Exposure parameters

| Name                                                                     | Description                                                                                                                                                                                                     | Value                                                               |
| ------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| `master.services.lb.type`                                                | Kubernetes Service type for the HTTP service                                                                                                                                                                    | `ClusterIP`                                                         |
| `master.services.lb.portEnabled`                                         | deploy port. Cannot be disabled when `auth.tls.enabled` is `false`. Listener can be disabled with `listeners.tcp = none`.                                                                                       | `true`                                                              |
| `master.services.lb.ports.deployHttp`                                    | Deploy master HTTP port value exposed on the service                                                                                                                                                            | `80`                                                                |
| `master.services.lb.ports.deployHttps`                                   | Deploy master HTTPS port value exposed on the service                                                                                                                                                           | `443`                                                               |
| `master.services.lb.portNames.deployHttp`                                | Deploy master HTTP port name                                                                                                                                                                                    | `deploy-http`                                                       |
| `master.services.lb.portNames.deployHttps`                               | Deploy master HTTPS port name                                                                                                                                                                                   | `deploy-https`                                                      |
| `master.services.lb.nodePorts.deployHttp`                                | Deploy master HTTP port value exposed on the node (in case of NodePort service)                                                                                                                                 | `""`                                                                |
| `master.services.lb.nodePorts.deployHttps`                               | Deploy master HTTPS port value exposed on the node (in case of NodePort service)                                                                                                                                | `""`                                                                |
| `master.services.lb.extraPorts`                                          | Extra ports to expose in the service                                                                                                                                                                            | `[]`                                                                |
| `master.services.lb.loadBalancerSourceRanges`                            | Address(es) that are allowed when service is `LoadBalancer`                                                                                                                                                     | `[]`                                                                |
| `master.services.lb.externalIPs`                                         | Set the ExternalIPs                                                                                                                                                                                             | `[]`                                                                |
| `master.services.lb.externalTrafficPolicy`                               | Enable client source IP preservation                                                                                                                                                                            | `Cluster`                                                           |
| `master.services.lb.loadBalancerIP`                                      | Set the LoadBalancerIP                                                                                                                                                                                          | `""`                                                                |
| `master.services.lb.clusterIP`                                           | Kubernetes service Cluster IP                                                                                                                                                                                   | `""`                                                                |
| `master.services.lb.labels`                                              | Service labels. Evaluated as a template                                                                                                                                                                         |                                                                     |
| `master.services.lb.labels.app.kubernetes.io/component`                  | Label with component name                                                                                                                                                                                       | `master`                                                            |
| `master.services.lb.annotations`                                         | Service annotations. Evaluated as a template                                                                                                                                                                    | `{}`                                                                |
| `master.services.lb.publishNotReadyAddresses`                            | Enable publishing of the DNS records when Pod is still not ready.                                                                                                                                               | `true`                                                              |
| `master.services.lb.sessionAffinity`                                     | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                            | `None`                                                              |
| `master.services.lb.sessionAffinityConfig`                               | Additional settings for the sessionAffinity                                                                                                                                                                     | `{}`                                                                |
| `master.services.pekko.type`                                             | Kubernetes Service type                                                                                                                                                                                         | `ClusterIP`                                                         |
| `master.services.pekko.portEnabled`                                      | deploy port.                                                                                                                                                                                                    | `true`                                                              |
| `master.services.pekko.ports.deployPekko`                                | Deploy master Pekko port value exposed on the service                                                                                                                                                           | `8180`                                                              |
| `master.services.pekko.ports.deployClusterPekko`                         | Deploy master Pekko cluster port value exposed on the service                                                                                                                                                   | `25520`                                                             |
| `master.services.pekko.portNames.deployPekko`                            | Deploy master Pekko port name                                                                                                                                                                                   | `deploy-pekko`                                                      |
| `master.services.pekko.portNames.deployJmxExporter`                      | Deploy master JMX exporter port name                                                                                                                                                                            | `deploy-jmx`                                                        |
| `master.services.pekko.portNames.deployClusterPekko`                     | Deploy master Pekko cluster port name                                                                                                                                                                           | `cluster-pekko`                                                     |
| `master.services.pekko.nodePorts.deployPekko`                            | Deploy master Pekko port value exposed on the node (in case of NodePort service)                                                                                                                                | `""`                                                                |
| `master.services.pekko.nodePorts.deployClusterPekko`                     | Deploy master Pekko cluster port value exposed on the node (in case of NodePort service)                                                                                                                        | `""`                                                                |
| `master.services.pekko.extraPorts`                                       | Extra ports to expose in the service                                                                                                                                                                            | `[]`                                                                |
| `master.services.pekko.loadBalancerSourceRanges`                         | Address(es) that are allowed when service is `LoadBalancer`                                                                                                                                                     | `[]`                                                                |
| `master.services.pekko.externalIPs`                                      | Set the ExternalIPs                                                                                                                                                                                             | `[]`                                                                |
| `master.services.pekko.externalTrafficPolicy`                            | Enable client source IP preservation                                                                                                                                                                            | `Cluster`                                                           |
| `master.services.pekko.loadBalancerIP`                                   | Set the LoadBalancerIP                                                                                                                                                                                          | `""`                                                                |
| `master.services.pekko.clusterIP`                                        | Kubernetes service Cluster IP                                                                                                                                                                                   | `None`                                                              |
| `master.services.pekko.labels`                                           | Service labels. Evaluated as a template                                                                                                                                                                         |                                                                     |
| `master.services.pekko.labels.app.kubernetes.io/component`               | Label with component name                                                                                                                                                                                       | `master`                                                            |
| `master.services.pekko.annotations`                                      | Service annotations. Evaluated as a template                                                                                                                                                                    | `{}`                                                                |
| `master.services.pekko.publishNotReadyAddresses`                         | Enable publishing of the DNS records when Pod is still not ready.                                                                                                                                               | `true`                                                              |
| `master.services.pekko.sessionAffinity`                                  | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                            | `None`                                                              |
| `master.services.pekko.sessionAffinityConfig`                            | Additional settings for the sessionAffinity                                                                                                                                                                     | `{}`                                                                |
| `master.podServiceTemplate.enabled`                                      | Enable Pod service template, if enabled generates for each pod dedicated service.                                                                                                                               | `false`                                                             |
| `master.podServiceTemplate.type`                                         | Kubernetes Service type                                                                                                                                                                                         | `NodePort`                                                          |
| `master.podServiceTemplate.name`                                         | Service name template, by default with dedicated pod number sufix.                                                                                                                                              | `{{ printf "%s-%d" (include "deploy.names.master" $) .podNumber }}` |
| `master.podServiceTemplate.serviceMode`                                  | Possible values are: SingleHostname (IncrementPort, MultiService), SinglePort (IncrementHostname, MultiService), MultiService (IncrementHostname, IncrementPort), SingleService (IncrementHostname, SinglePort) | `MultiService`                                                      |
| `master.podServiceTemplate.overrideHostnameSuffix`                       | together with overrideHostname composes full hostname of the exposed master pod                                                                                                                                 | `.{{ include "common.names.namespace" . }}.svc.cluster.local`       |
| `master.podServiceTemplate.overrideHostname`                             | Together with overrideHostnameSuffix composes full hostname of the exposed master pod                                                                                                                           | `{{ include "deploy.names.master" . }}-{{ .podNumber }}`            |
| `master.podServiceTemplate.overrideHostnames`                            | Together with overrideHostnameSuffix composes full hostname of the exposed worker pod                                                                                                                           | `[]`                                                                |
| `master.podServiceTemplate.portEnabled`                                  | deploy port. Cannot be disabled when `auth.tls.enabled` is `false`. Listener can be disabled with `listeners.tcp = none`.                                                                                       | `true`                                                              |
| `master.podServiceTemplate.ports.deployPekko`                            | Deploy master Pekko port value exposed on the service                                                                                                                                                           | `32180`                                                             |
| `master.podServiceTemplate.portNames.deployPekko`                        | Deploy master Pekko port name                                                                                                                                                                                   | `deploy-pekko`                                                      |
| `master.podServiceTemplate.nodePorts.deployPekko`                        | Deploy master Pekko port value exposed on the node (in case of NodePort service)                                                                                                                                | `32180`                                                             |
| `master.podServiceTemplate.extraPorts`                                   | Extra ports to expose in the service                                                                                                                                                                            | `[]`                                                                |
| `master.podServiceTemplate.loadBalancerSourceRanges`                     | Address(es) that are allowed when service is `LoadBalancer`                                                                                                                                                     | `[]`                                                                |
| `master.podServiceTemplate.externalIPs`                                  | Set the ExternalIPs                                                                                                                                                                                             | `[]`                                                                |
| `master.podServiceTemplate.externalTrafficPolicy`                        | Enable client source IP preservation                                                                                                                                                                            | `Local`                                                             |
| `master.podServiceTemplate.loadBalancerIP`                               | Set the LoadBalancerIP                                                                                                                                                                                          | `""`                                                                |
| `master.podServiceTemplate.clusterIPs`                                   | Kubernetes service Cluster IPs                                                                                                                                                                                  | `[]`                                                                |
| `master.podServiceTemplate.labels`                                       | Service labels. Evaluated as a template                                                                                                                                                                         |                                                                     |
| `master.podServiceTemplate.labels.app.kubernetes.io/component`           | Label with component name                                                                                                                                                                                       | `master`                                                            |
| `master.podServiceTemplate.annotations`                                  | Service annotations. Evaluated as a template                                                                                                                                                                    | `{}`                                                                |
| `master.podServiceTemplate.publishNotReadyAddresses`                     | Enable publishing of the DNS records when Pod is still not ready.                                                                                                                                               | `true`                                                              |
| `master.podServiceTemplate.sessionAffinity`                              | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                            | `None`                                                              |
| `master.podServiceTemplate.sessionAffinityConfig`                        | Additional settings for the sessionAffinity                                                                                                                                                                     | `{}`                                                                |
| `master.podServiceTemplate.podLabels`                                    | Deploy master Pod labels. Evaluated as a template                                                                                                                                                               |                                                                     |
| `master.podServiceTemplate.podLabels.statefulset.kubernetes.io/pod-name` | The name of pod put in the service label                                                                                                                                                                        | `{{ printf "%s-%d" (include "deploy.names.master" $) .podNumber }}` |

### Deploy worker parameters

| Name                                   | Description                                                                             | Value   |
| -------------------------------------- | --------------------------------------------------------------------------------------- | ------- |
| `worker.overrideName`                  | If set the template will override the STS name.                                         | `""`    |
| `worker.useIpAsHostname`               | Set IP address of the container as the hostname for the instance.                       | `false` |
| `worker.terminationGracePeriodSeconds` | Default duration in seconds k8s waits for container to exit before sending kill signal. | `90`    |
| `worker.replicaCount`                  | Number of Deploy worker replicas to deploy                                              | `3`     |

### Deploy Worker Image parameters

| Name                       | Description                                              | Value                                     |
| -------------------------- | -------------------------------------------------------- | ----------------------------------------- |
| `worker.image.registry`    | deploy worker image registry                             | `docker.io`                               |
| `worker.image.repository`  | deploy worker image repository                           | `xebialabsunsupported/deploy-task-engine` |
| `worker.image.tag`         | deploy worker image tag (immutable tags are recommended) | `{{ .Chart.AppVersion }}`                 |
| `worker.image.pullPolicy`  | deploy worker image pull policy                          | `IfNotPresent`                            |
| `worker.image.pullSecrets` | Specify docker-registry secret names as an array         | `[]`                                      |

### Worker debug parameters

| Name                               | Description                                                                                   | Value                                                                                                                       |
| ---------------------------------- | --------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `worker.diagnosticMode.enabled`    | Enable diagnostic mode (all probes will be disabled and the command will be overridden)       | `false`                                                                                                                     |
| `worker.diagnosticMode.command`    | Command to override all containers in the deployment                                          | `["/opt/xebialabs/tini"]`                                                                                                   |
| `worker.diagnosticMode.args`       | Args to override all containers in the deployment                                             | `["--","sleep","infinity"]`                                                                                                 |
| `worker.debugMode.enabled`         | Enable debug mode (it starts all process with debug agent)                                    | `false`                                                                                                                     |
| `worker.debugMode.remoteJvmParams` | Agent lib configuration line with port. Do port forwarding to the port you would like to use. | `{{- if .Values.worker.debugMode.enabled }} -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8001{{- end }}` |

### Worker DNS parameters

| Name                 | Description                 | Value |
| -------------------- | --------------------------- | ----- |
| `worker.hostAliases` | Deployment pod host aliases | `[]`  |
| `worker.dnsPolicy`   | DNS Policy for pod          | `""`  |
| `worker.dnsConfig`   | DNS Configuration pod       | `{}`  |

### Worker resource parameters

| Name                        | Description                                   | Value |
| --------------------------- | --------------------------------------------- | ----- |
| `worker.resources.limits`   | The resources limits for deploy containers    | `{}`  |
| `worker.resources.requests` | The requested resources for deploy containers | `{}`  |

### Worker Statefulset parameters

| Name                                                       | Description                                                                                                              | Value          |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | -------------- |
| `worker.health.enabled`                                    | Enable probes                                                                                                            | `true`         |
| `worker.health.periodScans`                                | Period seconds for probe                                                                                                 | `10`           |
| `worker.health.probeFailureThreshold`                      | Failure threshold for probe                                                                                              | `12`           |
| `worker.health.probesLivenessTimeout`                      | Initial delay seconds for livenessProbe                                                                                  | `60`           |
| `worker.health.probesReadinessTimeout`                     | Initial delay seconds for readinessProbe                                                                                 | `60`           |
| `worker.schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                | `""`           |
| `worker.podManagementPolicy`                               | Pod management policy                                                                                                    | `OrderedReady` |
| `worker.podLabels`                                         | deploy Pod labels. Evaluated as a template                                                                               |                |
| `worker.podLabels.app.kubernetes.io/component`             | Label with component name                                                                                                | `worker`       |
| `worker.podAnnotations`                                    | deploy Pod annotations. Evaluated as a template                                                                          | `{}`           |
| `worker.updateStrategy.type`                               | Update strategy type for deploy statefulset                                                                              | `OnDelete`     |
| `worker.statefulsetLabels`                                 | deploy statefulset labels. Evaluated as a template                                                                       |                |
| `worker.statefulsetLabels.app.kubernetes.io/component`     | Label with component name                                                                                                | `worker`       |
| `worker.statefulsetAnnotations`                            | Deploy worker statefulset annotations. Evaluated as a template                                                           | `{}`           |
| `worker.priorityClassName`                                 | Name of the priority class to be used by deploy pods, priority class needs to be created beforehand                      | `""`           |
| `worker.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `""`           |
| `worker.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`         |
| `worker.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`           |
| `worker.nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                    | `""`           |
| `worker.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                | `[]`           |
| `worker.affinity`                                          | Affinity for pod assignment. Evaluated as a template                                                                     | `{}`           |
| `worker.nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template                                                                  | `{}`           |
| `worker.tolerations`                                       | Tolerations for pod assignment. Evaluated as a template                                                                  | `[]`           |
| `worker.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`           |
| `worker.podSecurityContext.enabled`                        | Enable deploy pods' Security Context                                                                                     | `true`         |
| `worker.podSecurityContext.runAsUser`                      | Set Deploy pod's Security Context runAsUser                                                                              | `10001`        |
| `worker.podSecurityContext.fsGroup`                        | Set deploy pod's Security Context fsGroup                                                                                | `10001`        |
| `worker.containerSecurityContext.enabled`                  | Enabled deploy containers' Security Context                                                                              | `true`         |
| `worker.containerSecurityContext.runAsNonRoot`             | Set deploy container's Security Context runAsNonRoot                                                                     | `true`         |
| `worker.containerSecurityContext.allowPrivilegeEscalation` | Set deploy container's Security Context allowPrivilegeEscalation                                                         | `false`        |
| `worker.containerSecurityContext.capabilities`             | Set deploy container's Security Context capabilities                                                                     |                |
| `worker.containerSecurityContext.seccompProfile`           | Set deploy container's Security Context seccompProfile                                                                   |                |
| `worker.initContainers`                                    | Add init containers to the Deploy worker pod                                                                             | `[]`           |
| `worker.sidecars`                                          | Add sidecar containers to the Deploy worker pod                                                                          | `[]`           |

### Master Init Container parameters

| Name                                                               | Description                                                                                                                       | Value                               |
| ------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- |-------------------------------------|
| `worker.volumePermissions.enabled`                                 | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup`              | `false`                             |
| `worker.volumePermissions.image.registry`                          | Init container volume-permissions image registry                                                                                  | `docker.io`                         |
| `worker.volumePermissions.image.repository`                        | Init container volume-permissions image repository                                                                                | `bitnami/os-shell`                  |
| `worker.volumePermissions.image.tag`                               | Init container volume-permissions image tag                                                                                       | `12-debian-12-r16`                  |
| `worker.volumePermissions.image.digest`                            | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                                |
| `worker.volumePermissions.image.pullPolicy`                        | Init container volume-permissions image pull policy                                                                               | `IfNotPresent`                      |
| `worker.volumePermissions.image.pullSecrets`                       | Specify docker-registry secret names as an array                                                                                  | `[]`                                |
| `worker.volumePermissions.script`                                  | Script for changing the owner and group of the persistent volume(s). Paths are declared in the 'paths' variable.                  | _omitted too long default content_  |
| `worker.volumePermissions.resources.limits`                        | Init container volume-permissions resource limits                                                                                 | `{}`                                |
| `worker.volumePermissions.resources.requests`                      | Init container volume-permissions resource requests                                                                               | `{}`                                |
| `worker.volumePermissions.containerSecurityContext.runAsUser`      | User ID for the init container                                                                                                    | `0`                                 |
| `worker.volumePermissions.containerSecurityContext.runAsGroup`     | Group ID for the init container                                                                                                   | `0`                                 |
| `worker.volumePermissions.containerSecurityContext.runAsNonRoot`   | Set volume permissions init container's Security Context runAsNonRoot                                                             | `false`                             |
| `worker.volumePermissions.containerSecurityContext.seccompProfile` | Set volume permissions init container's Security Context seccompProfile                                                           |                                     |

### Worker Pod Disruption Budget configuration

| Name                        | Description                                                    | Value   |
| --------------------------- | -------------------------------------------------------------- | ------- |
| `worker.pdb.create`         | Enable/disable a Pod Disruption Budget creation                | `false` |
| `worker.pdb.minAvailable`   | Minimum number/percentage of pods that should remain scheduled | `1`     |
| `worker.pdb.maxUnavailable` | Maximum number/percentage of pods that may be made unavailable | `""`    |

### Worker Persistence parameters

| Name                                                     | Description                                      | Value                                        |
| -------------------------------------------------------- | ------------------------------------------------ | -------------------------------------------- |
| `worker.persistence.enabled`                             | Enable deploy data persistence using PVC         | `true`                                       |
| `worker.persistence.single`                              | Enable deploy data to use single PVC             | `false`                                      |
| `worker.persistence.storageClass`                        | PVC Storage Class for deploy data volume         | `""`                                         |
| `worker.persistence.selector`                            | Selector to match an existing Persistent Volume  | `{}`                                         |
| `worker.persistence.accessModes`                         | PVC Access Modes for deploy data volume          | `["ReadWriteOnce"]`                          |
| `worker.persistence.existingClaim`                       | Provide an existing PersistentVolumeClaims       | `""`                                         |
| `worker.persistence.size`                                | PVC Storage Request for deploy data volume       | `8Gi`                                        |
| `worker.persistence.annotations`                         | Persistence annotations. Evaluated as a template |                                              |
| `worker.persistence.annotations.helm.sh/resource-policy` | Persistence annotation for keeping created PVCs  | `keep`                                       |
| `worker.persistence.paths`                               | mounted paths for the Deploy worker              | `["/opt/xebialabs/deploy-task-engine/work"]` |

### Worker runtime parameters

| Name                                                  | Description                                                                                       | Value                                                      |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------- |------------------------------------------------------------|
| `worker.jvmArgs`                                      | Deploy worker JVM arguments                                                                       | `""`                                                       |
| `worker.command`                                      | Override default container command (useful when using custom images)                              | `["/opt/xebialabs/tini"]`                                  |
| `worker.args`                                         | Override default container args (useful when using custom images)                                 | `/opt/xebialabs/deploy-task-engine/bin/run-in-operator.sh` |
| `worker.lifecycleHooks`                               | Overwrite livecycle for the deploy container(s) to automate configuration before or after startup | `{}`                                                       |
| `worker.logback.globalLoggingLevel`                   | Global logging level. Possible values: "trace", "debug", "info", "warn", "error".                 | `info`                                                     |
| `worker.logback.scanEnabled`                          | Enables scanning of logback.xml.                                                                  | `true`                                                     |
| `worker.logback.scanPeriod`                           | Interval for checking logback.xml configuration.                                                  | `30 seconds`                                               |
| `worker.extraEnvVars`                                 | Extra environment variables to add to deploy pods                                                 | `[]`                                                       |
| `worker.extraEnvVarsCM`                               | Name of existing ConfigMap containing extra environment variables                                 | `""`                                                       |
| `worker.extraEnvVarsSecret`                           | Name of existing Secret containing extra environment variables (in case of sensitive data)        | `""`                                                       |
| `worker.containerPorts.deployPekko`                   | Deploy Pekko port value exposed on the worker container                                           | `8180`                                                     |
| `worker.containerPorts.deployJmxExporter`             | Deploy JMX exportet port value exposed on the worker container                                    | `9100`                                                     |
| `worker.extraContainerPorts`                          | Extra ports to be included in container spec, primarily informational                             | `[]`                                                       |
| `worker.configuration`                                | Deploy configuration file content: required cluster configuration                                 |                                                            |
| `worker.configuration.bin_run-in-operator-sh`         | The script for starting the worker with K8S configuration                                         |                                                            |
| `worker.configuration.bin_run-in-operator-sh.path`    | The path for the script for starting the worker with K8S configuration                            | `bin/run-in-operator.sh`                                   |
| `worker.configuration.bin_run-in-operator-sh.mode`    | The access mode for the script for starting the worker with K8S configuration                     | `755`                                                      |
| `worker.configuration.bin_run-in-operator-sh.content` | Content of the script for starting the worker with K8S configuration                              | _omitted too long default content_                         |
| `worker.extraConfiguration`                           | Configuration file content: extra configuration to be appended to deploy configuration            | `{}`                                                       |
| `worker.extraVolumeMounts`                            | Optionally specify extra list of additional volumeMounts                                          | `[]`                                                       |
| `worker.extraVolumes`                                 | Optionally specify extra list of additional volumes .                                             | `[]`                                                       |
| `worker.extraSecrets`                                 | Optionally specify extra secrets to be created by the chart.                                      | `{}`                                                       |
| `worker.extraSecretsPrependReleaseName`               | Set this flag to true if extraSecrets should be created with <release-name> prepended.            | `false`                                                    |

### Worker Exposure parameters

| Name                                                                     | Description                                                                           | Value                                                               |
| ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| `worker.services.pekko.type`                                             | Kubernetes Service type for the Deploy worker                                         | `ClusterIP`                                                         |
| `worker.services.pekko.portEnabled`                                      | Enable Deploy worker port.                                                            | `true`                                                              |
| `worker.services.pekko.ports.deployPekko`                                | Deploy worker Pekko port value exposed on the service                                 | `8180`                                                              |
| `worker.services.pekko.portNames.deployPekko`                            | Deploy worker Pekko port name                                                         | `deploy-pekko`                                                      |
| `worker.services.pekko.portNames.deployJmxExporter`                      | Deploy worker JMX exporter port name                                                  | `deploy-jmx`                                                        |
| `worker.services.pekko.nodePorts.deployPekko`                            | Deploy worker Pekko port value exposed on the node (in case of NodePort service)      | `""`                                                                |
| `worker.services.pekko.extraPorts`                                       | Extra ports to expose in the service                                                  | `[]`                                                                |
| `worker.services.pekko.loadBalancerSourceRanges`                         | Address(es) that are allowed when service is `LoadBalancer`                           | `[]`                                                                |
| `worker.services.pekko.externalIPs`                                      | Set the ExternalIPs                                                                   | `[]`                                                                |
| `worker.services.pekko.externalTrafficPolicy`                            | Enable client source IP preservation                                                  | `Cluster`                                                           |
| `worker.services.pekko.loadBalancerIP`                                   | Set the LoadBalancerIP                                                                | `""`                                                                |
| `worker.services.pekko.clusterIP`                                        | Kubernetes service Cluster IP                                                         | `None`                                                              |
| `worker.services.pekko.labels`                                           | Service labels. Evaluated as a template                                               |                                                                     |
| `worker.services.pekko.labels.app.kubernetes.io/component`               | Label with component name                                                             | `worker`                                                            |
| `worker.services.pekko.annotations`                                      | Service annotations. Evaluated as a template                                          | `{}`                                                                |
| `worker.services.pekko.publishNotReadyAddresses`                         | Enable publishing of the DNS records when Pod is still not ready.                     | `true`                                                              |
| `worker.services.pekko.sessionAffinity`                                  | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                  | `None`                                                              |
| `worker.services.pekko.sessionAffinityConfig`                            | Additional settings for the sessionAffinity                                           | `{}`                                                                |
| `worker.podServiceTemplate.enabled`                                      | Enable Pod service template, if enabled generates for each pod dedicated service.     | `false`                                                             |
| `worker.podServiceTemplate.type`                                         | Kubernetes Service type                                                               | `NodePort`                                                          |
| `worker.podServiceTemplate.name`                                         | Service name template, by default with dedicated pod number sufix.                    | `{{ printf "%s-%d" (include "deploy.names.worker" $) .podNumber }}` |
| `worker.podServiceTemplate.serviceMode`                                  | Possible values are: SingleHostname (IncrementPort, MultiService),                    | `MultiService`                                                      |
| `worker.podServiceTemplate.overrideHostnameSuffix`                       | together with overrideHostname composes full hostname of the exposed worker pod       | `.{{ include "common.names.namespace" . }}.svc.cluster.local`       |
| `worker.podServiceTemplate.overrideHostname`                             | together with overrideHostnameSuffix composes full hostname of the exposed worker pod | `{{ include "deploy.names.worker" . }}-{{ .podNumber }}`            |
| `worker.podServiceTemplate.overrideHostnames`                            | Together with overrideHostnameSuffix composes full hostname of the exposed worker pod | `[]`                                                                |
| `worker.podServiceTemplate.portEnabled`                                  | deploy port.                                                                          | `true`                                                              |
| `worker.podServiceTemplate.ports.deployPekko`                            | Deploy worker Pekko port value exposed on the service                                 | `32185`                                                             |
| `worker.podServiceTemplate.portNames.deployPekko`                        | Deploy worker Pekko port name                                                         | `deploy-pekko`                                                      |
| `worker.podServiceTemplate.nodePorts.deployPekko`                        | Deploy worker Pekko port value exposed on the node (in case of NodePort service)      | `32185`                                                             |
| `worker.podServiceTemplate.extraPorts`                                   | Extra ports to expose in the service                                                  | `[]`                                                                |
| `worker.podServiceTemplate.loadBalancerSourceRanges`                     | Address(es) that are allowed when service is `LoadBalancer`                           | `[]`                                                                |
| `worker.podServiceTemplate.externalIPs`                                  | Set the ExternalIPs                                                                   | `[]`                                                                |
| `worker.podServiceTemplate.externalTrafficPolicy`                        | Enable client source IP preservation                                                  | `Local`                                                             |
| `worker.podServiceTemplate.loadBalancerIP`                               | Set the LoadBalancerIP                                                                | `""`                                                                |
| `worker.podServiceTemplate.clusterIPs`                                   | Kubernetes service Cluster IPs                                                        | `[]`                                                                |
| `worker.podServiceTemplate.labels`                                       | Service labels. Evaluated as a template                                               |                                                                     |
| `worker.podServiceTemplate.labels.app.kubernetes.io/component`           | Label with component name                                                             | `worker`                                                            |
| `worker.podServiceTemplate.annotations`                                  | Service annotations. Evaluated as a template                                          | `{}`                                                                |
| `worker.podServiceTemplate.publishNotReadyAddresses`                     | Enable publishing of the DNS records when Pod is still not ready.                     | `true`                                                              |
| `worker.podServiceTemplate.sessionAffinity`                              | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                  | `None`                                                              |
| `worker.podServiceTemplate.sessionAffinityConfig`                        | Additional settings for the sessionAffinity                                           | `{}`                                                                |
| `worker.podServiceTemplate.podLabels`                                    | Deploy worker Pod labels. Evaluated as a template                                     |                                                                     |
| `worker.podServiceTemplate.podLabels.statefulset.kubernetes.io/pod-name` | The name of pod put in the service label                                              | `{{ printf "%s-%d" (include "deploy.names.worker" $) .podNumber }}` |

### Deploy Network Policy configuration

| Name                            | Description                                                                          | Value   |
| ------------------------------- | ------------------------------------------------------------------------------------ | ------- |
| `networkPolicy.enabled`         | Enable creation of NetworkPolicy resources                                           | `false` |
| `networkPolicy.allowExternal`   | Don't require client label for connections                                           | `true`  |
| `networkPolicy.additionalRules` | Additional NetworkPolicy Ingress "from" rules to set. Note that all rules are OR-ed. | `[]`    |

### Deploy Metrics Parameters

| Name              | Description                                    | Value   |
| ----------------- | ---------------------------------------------- | ------- |
| `metrics.enabled` | Enable exposing Deploy metrics to be gathered. | `false` |

### Deploy OIDC parameters

| Name                                   | Description                                                                                                       | Value   |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ------- |
| `oidc.enabled`                         | Enable the OIDC configuration                                                                                     | `false` |
| `oidc.clientId`                        | Client ID                                                                                                         | `nil`   |
| `oidc.clientSecret`                    | Client secret                                                                                                     | `nil`   |
| `oidc.clientAuthMethod`                | Client authentication method                                                                                      | `nil`   |
| `oidc.clientAuthJwt.enable`            | Enable Client Authentication Using private_key_jwt                                                                | `false` |
| `oidc.clientAuthJwt.jwsAlg`            | Expected JSON Web Algorithm                                                                                       | `nil`   |
| `oidc.clientAuthJwt.tokenKeyId`        | Token key identifier 'kid' header - set it if your OpenID Connect provider requires it                            | `nil`   |
| `oidc.clientAuthJwt.keyStore.enable`   | Enable keystore                                                                                                   | `false` |
| `oidc.clientAuthJwt.keyStore.path`     | The key store file path                                                                                           | `nil`   |
| `oidc.clientAuthJwt.keyStore.password` | The key store password                                                                                            | `nil`   |
| `oidc.clientAuthJwt.keyStore.type`     | The type of keystore                                                                                              | `nil`   |
| `oidc.clientAuthJwt.key.enable`        | Enable private key                                                                                                | `false` |
| `oidc.clientAuthJwt.key.alias`         | Private key alias inside the key store                                                                            | `nil`   |
| `oidc.clientAuthJwt.key.password`      | Private key password                                                                                              | `nil`   |
| `oidc.emailClaim`                      | Email claim                                                                                                       | `nil`   |
| `oidc.issuer`                          | OpenID Provider Issuer here                                                                                       | `nil`   |
| `oidc.keyRetrievalUri`                 | The jwks_uri to retrieve keys                                                                                     | `nil`   |
| `oidc.accessTokenUri`                  | The redirect URI to use for returning the access token                                                            | `nil`   |
| `oidc.userAuthorizationUri`            | The authorize endpoint to request tokens or authorization codes via the browser                                   | `nil`   |
| `oidc.logoutUri`                       | The logout endpoint to revoke token via the browser                                                               | `nil`   |
| `oidc.redirectUri`                     | The redirectUri endpoint must always point to the /login/external-login Deploy endpoint.                          | `nil`   |
| `oidc.postLogoutRedirectUri`           | If you need to redirect to the login page after logout, you can use your redirectUri as the postLogoutRedirectUri | `nil`   |
| `oidc.rolesClaimName`                  | Roles claim                                                                                                       | `nil`   |
| `oidc.userNameClaimName`               | A unique username for both internal and external users.                                                           | `nil`   |
| `oidc.scopes`                          | Fields described here must be present in the scope.                                                               | `nil`   |
| `oidc.idTokenJWSAlg`                   | The ID token signature verification algorithm                                                                     | `nil`   |
| `oidc.accessToken.enable`              | Enable access token                                                                                               | `false` |
| `oidc.accessToken.issuer`              | Expected issuer 'iss' claim value                                                                                 | `nil`   |
| `oidc.accessToken.audience`            | Expected audience 'aud' claim value                                                                               | `nil`   |
| `oidc.accessToken.keyRetrievalUri`     | The jwks_uri to retrieve keys for the token                                                                       | `nil`   |
| `oidc.accessToken.jwsAlg`              | Expected JSON Web Algorithm                                                                                       | `nil`   |
| `oidc.accessToken.secretKey`           | The secret key if MAC based algorithms is used for the token                                                      | `nil`   |
| `oidc.loginMethodDescription`          | Description of the method used                                                                                    | `nil`   |
| `oidc.proxyHost`                       | Proxy host                                                                                                        | `nil`   |
| `oidc.proxyPort`                       | Proxy port                                                                                                        | `nil`   |

### Deploy Common parameters

| Name                | Description                                                                           | Value           |
| ------------------- | ------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`      | String to partially override deploy.fullname template (will maintain the deploy name) | `""`            |
| `fullnameOverride`  | String to fully override deploy.fullname template                                     | `""`            |
| `namespaceOverride` | String to fully override common.names.namespace                                       | `""`            |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                  | `""`            |
| `clusterDomain`     | Kubernetes Cluster Domain                                                             | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the deploy                                      | `[]`            |
| `commonAnnotations` | Annotations to add to all deployed objects                                            | `{}`            |
| `commonLabels`      | Labels to add to all deployed objects                                                 | `{}`            |

### Ingress parameters

| Name                       | Description                                                                                                                      | Value                    |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.enabled`          | Enable ingress resource for Management console                                                                                   | `false`                  |
| `ingress.path`             | Path for the default host. You may need to set this to '/*' in order to use this with ALB ingress controllers.                   | `/`                      |
| `ingress.pathType`         | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.hostname`         | Default host for the ingress resource                                                                                            | `""`                     |
| `ingress.annotations`      | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `nil`                    |
| `ingress.tls`              | Enable TLS configuration for the hostname defined at `ingress.hostname` parameter                                                | `false`                  |
| `ingress.selfSigned`       | Set this to true in order to create a TLS secret for this ingress record                                                         | `false`                  |
| `ingress.extraHosts`       | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`       | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraRules`       | The list of additional rules to be added to this ingress record. Evaluated as a template                                         | `[]`                     |
| `ingress.extraTls`         | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`          | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.ingressClassName` | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |

### OpenShift Route parameters

| Name                                      | Description                                                                                        | Value   |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------- | ------- |
| `route.enabled`                           | Enable route resource                                                                              | `false` |
| `route.path`                              | Path for the default host.                                                                         | `/`     |
| `route.hostname`                          | Default host for the route resource                                                                | `""`    |
| `route.annotations`                       | Additional annotations for the route resource.                                                     |         |
| `route.tls.enabled`                       | Enable the route TLS configuration                                                                 | `false` |
| `route.tls.secretName`                    | Name of the secret to use with Route TLS setup                                                     | `""`    |
| `route.tls.key`                           | key in PEM-encoded format                                                                          | `""`    |
| `route.tls.certificate`                   | certificate in PEM-encoded format                                                                  | `""`    |
| `route.tls.caCertificate`                 | CA certificate in a PEM-encoded format                                                             | `""`    |
| `route.tls.destinationCACertificate`      | destination CA certificate in a PEM-encoded format (the Deploy master certificate)                 | `""`    |
| `route.tls.insecureEdgeTerminationPolicy` | Redirect HTTP to HTTPS. The only valid values are None, Redirect, or empty for disabled.           | `""`    |
| `route.tls.termination`                   | The accepted values are edge, passthrough and reencrypt.                                           | `edge`  |
| `route.tls.selfSigned`                    | if set to `true` the key and certificate will be auto generated and set in the route configuration | `false` |

### Deploy RBAC parameters

| Name                                          | Description                                                                                | Value  |
| --------------------------------------------- | ------------------------------------------------------------------------------------------ | ------ |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for deploy pods                                          | `true` |
| `serviceAccount.name`                         | Name of the created serviceAccount                                                         | `""`   |
| `serviceAccount.automountServiceAccountToken` | Auto-mount the service account token in the pod                                            | `true` |
| `serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if `create` is `true`. | `{}`   |
| `rbac.create`                                 | Whether RBAC rules should be created                                                       | `true` |

### Deploy Busy-box parameters

| Name                        | Description                                      | Value             |
| --------------------------- | ------------------------------------------------ | ----------------- |
| `busyBox.image.registry`    | busyBox container image registry                 | `docker.io`       |
| `busyBox.image.repository`  | busyBox container image repository               | `library/busybox` |
| `busyBox.image.tag`         | busyBox container image tag                      | `stable`          |
| `busyBox.image.pullPolicy`  | busyBox container image pull policy              | `IfNotPresent`    |
| `busyBox.image.pullSecrets` | Specify docker-registry secret names as an array | `[]`              |

### Ingress HAProxy

| Name                                      | Description                                                | Value          |
| ----------------------------------------- | ---------------------------------------------------------- | -------------- |
| `haproxy-ingress.install`                 | Enable Haproxy Ingress helm subchart installation          | `false`        |
| `haproxy-ingress.controller.ingressClass` | Name of the ingress class to route through this controller | `haproxy-daid` |
| `haproxy-ingress.controller.service.type` | Kubernetes Service type for Controller                     | `LoadBalancer` |

### Ingress Nginx

| Name                                                            | Description                                                           | Value                       |
| --------------------------------------------------------------- | --------------------------------------------------------------------- | --------------------------- |
| `nginx-ingress-controller.install`                              | Enable NGINX Ingress Controller helm subchart installation            | `false`                     |
| `nginx-ingress-controller.image.tag`                            | NGINX Ingress Controller image tag (immutable tags are recommended)   | `1.9.6-debian-12-r8`        |
| `nginx-ingress-controller.defaultBackend.image.tag`             | Default backend image tag (immutable tags are recommended)            | `1.25.4-debian-12-r3`       |
| `nginx-ingress-controller.extraArgs`                            | Additional command line arguments to pass to nginx-ingress-controller |                             |
| `nginx-ingress-controller.extraArgs.ingress-class`              | Name of the IngressClass resource                                     | `nginx-daid`                |
| `nginx-ingress-controller.ingressClassResource.name`            | Name of the IngressClass resource                                     | `nginx-daid`                |
| `nginx-ingress-controller.ingressClassResource.controllerClass` | IngressClass identifier for the controller                            | `k8s.io/ingress-nginx-daid` |
| `nginx-ingress-controller.replicaCount`                         | Desired number of Controller pods                                     | `1`                         |

### Traffic exposure parameters

| Name                                    | Description                            | Value          |
| --------------------------------------- | -------------------------------------- | -------------- |
| `nginx-ingress-controller.service.type` | Kubernetes Service type for Controller | `LoadBalancer` |

### Postgresql

| Name                   | Description                                           | Value                 |
| ---------------------- | ----------------------------------------------------- | --------------------- |
| `postgresql.install`   | Enable PostgreSQL helm subchart installation          | `true`                |
| `postgresql.image.tag` | PostgreSQL image tag (immutable tags are recommended) | `15.6.0-debian-12-r7` |
| `postgresql.hasReport` | Indicating that reporting database is enabled         | `true`                |

### PostgreSQL Primary parameters

| Name                                                    | Description                                                                             | Value                                                    |
| ------------------------------------------------------- | --------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `postgresql.primary.initdb.scriptsSecret`               | Secret with scripts to be run at first boot (in case it contains sensitive information) | `{{ include "postgresql.v1.primary.fullname" . }}-deploy` |
| `postgresql.primary.extendedConfiguration`              | Extended PostgreSQL Primary configuration (appended to main or default configuration)   | `max_connections = 300`                                  |
| `postgresql.primary.persistence.enabled`                | Enable PostgreSQL Primary data persistence using PVC                                    | `true`                                                   |
| `postgresql.primary.persistence.accessModes`            | PVC Access Mode for PostgreSQL volume                                                   | `["ReadWriteOnce"]`                                      |
| `postgresql.primary.persistence.storageClass`           | PVC Storage Class for PostgreSQL Primary data volume                                    | `""`                                                     |
| `postgresql.primary.persistence.size`                   | PVC Storage Request for PostgreSQL volume                                               | `8Gi`                                                    |
| `postgresql.primary.persistence.existingClaim`          | Name of an existing PVC to use                                                          | `""`                                                     |
| `postgresql.primary.resources.requests.memory`          | The requested memory for the PostgreSQL Primary containers                              | `256Mi`                                                  |
| `postgresql.primary.resources.requests.cpu`             | The requested cpu for the PostgreSQL Primary containers                                 | `250m`                                                   |
| `postgresql.primary.service.ports.postgresql`           | PostgreSQL service port                                                                 | `5432`                                                   |
| `postgresql.primary.service.type`                       | Kubernetes Service type                                                                 | `ClusterIP`                                              |
| `postgresql.primary.securityContextConstraints.enabled` | Enabled SecurityContextConstraints for Postgresql (only on Openshift)                   | `true`                                                   |

### Postgresql Authentication parameters

| Name                                 | Description                                                                                            | Value      |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------ | ---------- |
| `postgresql.auth.enablePostgresUser` | Assign a password to the "postgres" admin user. Otherwise, remote access will be blocked for this user | `true`     |
| `postgresql.auth.username`           | Name for a custom user to create                                                                       | `postgres` |
| `postgresql.auth.postgresPassword`   | Password for the "postgres" admin user. Ignored if `auth.existingSecret` is provided                   | `postgres` |
| `postgresql.serviceAccount.create`   | Enable creation of ServiceAccount for PostgreSQL pod                                                   | `true`     |

### Postgresql Volume Permissions parameters

| Name                                     | Description                                                                     | Value              |
| ---------------------------------------- | ------------------------------------------------------------------------------- | ------------------ |
| `postgresql.volumePermissions.enabled`   | Enable init container that changes the owner and group of the persistent volume | `true`             |
| `postgresql.volumePermissions.image.tag` | Init container volume-permissions image tag (immutable tags are recommended)    | `12-debian-12-r16` |

### RabbitMQ

| Name                                     | Description                                                                                         | Value                                            |
| ---------------------------------------- | --------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| `rabbitmq.install`                       | Enable Rabbitmq helm subchart installation                                                          | `true`                                           |
| `rabbitmq.image.tag`                     | RabbitMQ image tag (immutable tags are recommended)                                                 | `3.12.13-debian-12-r2`                           |
| `rabbitmq.clustering.forceBoot`          | Force boot of an unexpectedly shut down cluster (in an unexpected order).                           | `true`                                           |
| `rabbitmq.replicaCount`                  | Number of RabbitMQ replicas to deploy                                                               | `3`                                              |
| `rabbitmq.auth.username`                 | RabbitMQ application username                                                                       | `guest`                                          |
| `rabbitmq.auth.password`                 | RabbitMQ application password                                                                       | `guest`                                          |
| `rabbitmq.auth.existingErlangSecret`     | Existing secret with RabbitMQ Erlang cookie (must contain a value for `rabbitmq-erlang-cookie` key) | `{{ include "common.names.fullname" . }}-deploy` |
| `rabbitmq.extraPlugins`                  | Extra plugins to enable (single string containing a space-separated list)                           | `rabbitmq_jms_topic_exchange`                    |
| `rabbitmq.loadDefinition.enabled`        | Enable loading a RabbitMQ definitions file to configure RabbitMQ                                    | `true`                                           |
| `rabbitmq.loadDefinition.file`           | Name of the definitions file                                                                        | `/app/deploy_load_definition.json`               |
| `rabbitmq.loadDefinition.existingSecret` | Existing secret with the load definitions file                                                      | `{{ include "common.names.fullname" . }}-deploy` |
| `rabbitmq.extraConfiguration`            | Configuration file content: extra configuration to be appended to RabbitMQ configuration            | `""`                                             |

### RabbitMQ persistence parameters

| Name                                                         | Description                                                                       | Value               |
| ------------------------------------------------------------ | --------------------------------------------------------------------------------- | ------------------- |
| `rabbitmq.persistence.enabled`                               | Enable RabbitMQ data persistence using PVC                                        | `true`              |
| `rabbitmq.persistence.accessModes`                           | PVC Access Modes for RabbitMQ data volume                                         | `["ReadWriteOnce"]` |
| `rabbitmq.persistence.storageClass`                          | PVC Storage Class for RabbitMQ data volume                                        | `""`                |
| `rabbitmq.persistence.size`                                  | PVC Storage Request for RabbitMQ data volume                                      | `8Gi`               |
| `rabbitmq.containerSecurityContext.allowPrivilegeEscalation` | Set volume permissions init container's Security Context allowPrivilegeEscalation | `false`             |
| `rabbitmq.containerSecurityContext.capabilities`             | Set volume permissions init container's Security Context capabilities             |                     |
| `rabbitmq.containerSecurityContext.seccompProfile`           | Set volume permissions init container's Security Context seccompProfile           |                     |
| `rabbitmq.securityContextConstraints.enabled`                | Enabled SecurityContextConstraints for Rabbitmq (only on Openshift)               | `true`              |

### RabbitMQ Exposure parameters

| Name                    | Description             | Value       |
| ----------------------- | ----------------------- | ----------- |
| `rabbitmq.service.type` | Kubernetes Service type | `ClusterIP` |

### RabbitMQ Init Container Parameters

| Name                                                                 | Description                                                                                                          | Value              |
| -------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------------------ |
| `rabbitmq.volumePermissions.enabled`                                 | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup` | `true`             |
| `rabbitmq.volumePermissions.image.tag`                               | Init container volume-permissions image tag (immutable tags are recommended)                                         | `12-debian-12-r16` |
| `rabbitmq.volumePermissions.containerSecurityContext.runAsUser`      | User ID for the init container                                                                                       | `0`                |
| `rabbitmq.volumePermissions.containerSecurityContext.runAsGroup`     | Group ID for the init container                                                                                      | `0`                |
| `rabbitmq.volumePermissions.containerSecurityContext.runAsNonRoot`   | Set volume permissions init container's Security Context runAsNonRoot                                                | `false`            |
| `rabbitmq.volumePermissions.containerSecurityContext.seccompProfile` | Set volume permissions init container's Security Context seccompProfile                                              |                    |
