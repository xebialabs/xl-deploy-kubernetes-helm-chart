---
sidebar_position: 14
---

# Make custom configuration for the Deploy

## Requirements

- Running Deploy installation on k8s cluster
- `kubectl` connected to the cluster
- Deploy operator with the following versions or above:
  - 10.2.18
  - 10.3.16
  - 22.0.8
  - 22.1.6
  - 22.2.2

## Steps

1. Download current template configuration file that exists on you Deploy pod that is running.
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
