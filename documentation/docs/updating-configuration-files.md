---
sidebar_position: 13
---

# Update deployit.conf for Deploy master and worker

Get current deployit.conf.template file from the master node:
```shell
❯ kubectl cp dai-xld-digitalai-deploy-master-0:/opt/xebialabs/xl-deploy-server/default-conf/deployit.conf.template ./deployit.conf.template
```

Create following template file to append to it the retrieved `./deployit.conf.template`:
```shell
❯ cat config-patch-deployit.yaml.template
apiVersion: v1
kind: ConfigMap
metadata:
  name: deployit-conf-template
  labels:
    app: digitalai-deploy
data:
  deployit.conf: |
```

Merge the files:
```shell
❯ cat config-patch-deployit.yaml.template > config-patch-deployit-template.yaml
❯ sed -e 's/^/     /' deployit.conf.template >> config-patch-deployit-template.yaml
```

Change the config in the `config-patch-deployit-template.yaml`.

Create the config map with `config-patch-deployit-template.yaml`:
```shell
❯ kubectl create -f config-patch-deployit.yaml
```

Get all statefulsets (master statefulset will be suffixed with `-master`):
```shell
❯ kubectl get sts -o name
```

Change the stateful set for the master server by adding volume mounts and volumes:
```shell
❯ kubectl get statefulset.apps/dai-xld-digitalai-deploy-master -o yaml \
    | yq eval '.spec.template.spec.containers[0].volumeMounts += {
        "mountPath": "/opt/xebialabs/xl-deploy-server/default-conf/deployit.conf.template",
        "name": "deployit-conf-template-volume",
        "subPath": "deployit.conf.template"
      }' - \
    | yq eval '.spec.template.spec.volumes += [{
        "name": "deployit-conf-template-volume",
        "configMap": {
          "name": "deployit-conf-template"
        }
      }]' - \
    | kubectl replace -f -
```

Change the stateful set for the master worker by adding volume mounts and volumes:
```shell
❯ kubectl get statefulset.apps/dai-xld-digitalai-deploy-worker -o yaml \
    | yq eval '.spec.template.spec.containers[0].volumeMounts += {
        "mountPath": "/opt/xebialabs/xl-deploy-server/default-conf/deployit.conf.template",
        "name": "deployit-conf-template-volume",
        "subPath": "deployit.conf.template"
      }' - \
    | yq eval '.spec.template.spec.volumes += [{
        "name": "deployit-conf-template-volume",
        "configMap": {
          "name": "deployit-conf-template"
        }
      }]' - \
    | kubectl replace -f -
```

## Upgrade process if you have updated files with config maps
