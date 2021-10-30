---
sidebar_position: 8
---

# Uninstalling Helm Chart

To uninstall/delete the `xld-production` deployment:
```bash
helm delete xld-production
```

:::note
Shutting down worker from XLD GUI is not supported because of replicaset functionality of Kubernetes.
:::
