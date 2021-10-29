---
sidebar_position: 11
---

# Development

Let's have a look here about the easiest way to setup the cluster for a development on a local computer.

1. Copy `values-haproxy.yaml` or `values-nginx.yaml` and rename it as `values.yaml` 
2. Replace all usages in `values.yaml` of `storageClass: "-"` to `storageClass: "standard"`. This way we will use
local file system as a dynamic storage class with no need of configuring NFS server.
3. Define 

```yaml title=values.yaml
AdminPassword:
  admin

xldLicense:
    # Convert xl-deploy.lic files content to base64
```

4. Comment out `RepositoryKeystore` and `KeystorePassphrase`

5. Turn of persistence with

```yaml
Persistence:
  Enabled: false
``` 

6. You can also change `XldMasterCount` and `XldWorkerCount` to 1 or 2. Depends on your computer capacity.
Same for rabbitmq, on dev environment, you can use just 1 replica.

Once all of that is done you are ready to run it from the root of the project:
`helm install xld-production .`
Only make sure, that you installed kubernetes (currently it works on 1.17-1.20) and helm. 

When you want to clean it up: `helm delete xld-production` plus you have to remove your `pvc`, like
`kubectl delete pvc data-xld-production-postgresql-0 data-xld-production-rabbitmq-0`. <br/>
You might have slightly different names, if so, first list `pvcs` to check what you have with `kubectl get pvc`.
