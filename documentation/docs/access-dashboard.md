---
sidebar_position: 9
---

# Access Dashboard

:::caution
This is internal documentation. This document can be used only if it was recommended by the Support Team.
:::

:::caution
From 10.2 version helm chart is not used directly. Use operator based installation instead.
:::


By default, the NodePort service is exposed externally on the available k8s worker nodes and can be seen by running below command
```bash
kubectl get service
```
For production grade setups, we recommend using LoadBalancer as service type.

 For OnPremise Cluster, you can access Digital.ai Deploy UI from an outside cluster with below link 

 [http://ingress-loadbalancer-DNS:NodePort/xl-deploy/](http://ingress-loadbalancer-DNS-colon-NodePort/xl-deploy/)
 i.e. [http://NodeIP:NodePort/xl-deploy/](http://NodeIP-colon-NodePort/xl-deploy/)

Similarly for EKS, access Digital.ai Deploy UI using below link 

 [http://ingress-loadbalancer-DNS/xl-deploy/](http://ingress-loadbalancer-DNS/xl-deploy/)
 i.e. [http://ingress-loadbalancer-DNS:NodePort/xl-deploy/](http://ingress-loadbalancer-DNS-colon-NodePort/xl-deploy/)

The path should be unique across the Kubernetes cluster.(Ex "/xl-deploy/") 
