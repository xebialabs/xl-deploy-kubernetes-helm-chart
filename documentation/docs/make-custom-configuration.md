---
sidebar_position: 14
---

# Make custom configuration for the Deploy

:::caution
This is internal documentation. This document can be used only if it was recommended by the Support Team.
:::

## Requirements

- Running Deploy installation on k8s cluster
- `kubectl` connected to the cluster
- Deploy operator with the following versions or above:
  - 10.2.18
  - 10.3.16
  - 22.0.8
  - 22.1.6
  - 22.2.2



## Custom configuration of deployit-security.xml from master pods

### Steps

1. Download current template configuration file that exists on master Deploy pod that is running.
   For example, if you want to update deployit-security.xml, it is in the `/opt/xebialabs/xl-deploy-server/conf/deployit-security.xml` in master pod.

    ```shell
    kubectl cp digitalai/dai-xld-digitalai-deploy-master-0:/opt/xebialabs/xl-deploy-server/conf/deployit-security.xml .
    ```

2. Update the CR file or CR on the cluster

   Use that file to update your CR file under `spec.deploy.configurationManagement.master.configuration.scriptData` path. Add there the content of the `deployit-security.xml` file under the `deployit-security.xml` key.

   Also update the script under the `spec.deploy.configurationManagement.master.configuration.script` path. Add there 

   For example:

  ```yaml
  ...
          script: |-
            ...
            cp /opt/xebialabs/xl-deploy-server/xld-configuration-management/deployit-security.xml /opt/xebialabs/xl-deploy-server/conf/deployit-security.xml && echo "Changing the deployit-security.xml";
          scriptData:
            ...
            deployit-security.xml: |-
              <?xml version="1.0" encoding="UTF-8"?>
              ...
  ```
    
   Note: This is the example of master configuration. Under spec.deploy.configurationManagement there are also worker and centralConfiguration sections.


3. Save and apply changes from the CR file. Restart pods. 

    ```shell
    kubectl rollout restart sts dai-xld-digitalai-deploy-master -n digitalai
    ```



## Custom configuration of deployit.conf.template from master pods

### Steps

1. Download current template configuration file that exists on master Deploy pod that is running.
For example, if you want to update deployit-security.xml, it is in the `/opt/xebialabs/xl-deploy-server/default-conf/deployit.conf.template` in master pod.

    ```shell
    kubectl cp digitalai/dai-xld-digitalai-deploy-master-0:/opt/xebialabs/xl-deploy-server/default-conf/deployit.conf.template .
    ```

2. Update the CR file or CR on the cluster

   Use that file to update your CR file under `spec.deploy.configurationManagement.master.configuration.scriptData` path. Add there the content of the `deployit.conf.template` file under the `deployit.conf.template` key.

   Also update the script under the `spec.deploy.configurationManagement.master.configuration.script` path. Add there 

   For example:

  ```yaml
  ...
          script: |-
            ...
            cp /opt/xebialabs/xl-deploy-server/xld-configuration-management/deployit.conf.template /opt/xebialabs/xl-deploy-server/default-conf/deployit.conf.template && echo "Changing the deployit.conf.template";
          scriptData:
            ...
            deployit.conf.template: |-
              # Template for non-HOCON XL Deploy configuration file
              #
              admin.password=${ADMIN_PASSWORD}
              ...
  ```
  Note: This is the example of master configuration. Under spec.deploy.configurationManagement there are also worker and centralConfiguration sections.

3. Save and apply changes from the CR file. Restart pods. 

    ```shell
    kubectl rollout restart sts dai-xld-digitalai-deploy-master -n digitalai
    ```

## Custom configuration of deploy-server.yaml.template from cc pods

### Steps

1. Download current template configuration file that exists on cc Deploy pod that is running.
   For example, if you want to update deploy-server.yaml.template, it is in the `/opt/xebialabs/central-configuration-server/central-conf/deploy-server.yaml.template` in master pod.

    ```shell
    kubectl cp digitalai/dai-xld-digitalai-deploy-cc-server-0:/opt/xebialabs/central-configuration-server/central-conf/deploy-server.yaml.template .
    ```

2. Update the CR file or CR on the cluster

   Use that file to update your CR file under `spec.deploy.configurationManagement.centralConfiguration.configuration.scriptData` path. Add there the content of the `deploy-server.yaml.template` file under the `deploy-server.yaml.template` key.

   Also update the script under the `spec.deploy.configurationManagement.centralConfiguration.configuration.script` path. Add there 

   For example:

  ```yaml
  ...
          script: |-
            ...
            cp /opt/xebialabs/central-configuration-server/xld-configuration-management/deploy-server.yaml.template /opt/xebialabs/central-configuration-server/central-conf/deploy-server.yaml.template && echo "Changing the deploy-server.yaml.template";
          scriptData:
            ...
            deploy-server.yaml.template: |-
              deploy.server:
              ...
  ```
  3. If you have oidc enabled in CR, in that case disable it. Because the changes that are from there will conflict with your changes in the `deploy-server.yaml.template` file.

    Just in CR file put `spec.oidc.enabled: false`.
    
   Note: when you disable oidc in CR, `/opt/xebialabs/central-configuration-server/centralConfiguration/deploy-oidc.yaml` will be removed. For this reason, it is necessary to copy this file also. In `spec.deploy.configurationManagement.centralConfiguration.configuration.script` you would have:
   
   ```yaml
  ...
          script: |-
            ...
            cp /opt/xebialabs/central-configuration-server/xld-configuration-management/deploy-server.yaml.template /opt/xebialabs/central-configuration-server/central-conf/deploy-server.yaml.template && echo "Changing the deploy-server.yaml.template";
            cp /opt/xebialabs/central-configuration-server/xld-configuration-management/deploy-oidc.yaml /opt/xebialabs/central-configuration-server/centralConfiguration/deploy-oidc.yaml && echo "Changing the deploy-oidc.yaml";
          scriptData:
            ...
            deploy-server.yaml.template: |-
              deploy.server:
                ...
            deploy-oidc.yaml: |-
              deploy.security:
                ...
  ```

  4. Save and apply changes from the CR file. Restart pods.

  ```shell
  kubectl rollout restart sts dai-xld-digitalai-deploy-cc-server -n digitalai
  kubectl rollout restart sts dai-xld-digitalai-deploy-master -n digitalai
  kubectl rollout restart sts dai-xld-digitalai-deploy-worker -n digitalai
  ```

