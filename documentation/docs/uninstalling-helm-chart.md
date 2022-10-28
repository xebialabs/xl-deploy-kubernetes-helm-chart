---
sidebar_position: 8
---

:::caution
This is internal documentation. This document can be used only if it was recommended by the Support Team.
:::

:::caution
From 10.2 version helm chart is not used directly. Use operator based installation instead.
:::

# Uninstalling Helm Chart

To uninstall/delete the `xld-production` deployment:
```bash
helm delete xld-production
```

:::note
Shutting down worker from XLD GUI is not supported because of replicaset functionality of Kubernetes.
:::
