---
sidebar_position: 2
---

# Prerequisites

:::caution
This is internal documentation. This document can be used only if it was recommended by the Support Team.
:::

:::caution
From 10.2 version helm chart is not used directly. Use operator based installation instead.
:::

* Kubernetes v1.17+
* A running Kubernetes cluster
	- Dynamic storage provisioning enabled
	- StorageClass for persistent storage. The [Installing StorageClass Helm Chart](#installing-storageclass-helm-chart) section provides steps to install storage class on OnPremise Kubernetes cluster and AWS Elastic Kubernetes Service(EKS) cluster.
	- StorageClass which is expected to be used with Digital.ai Deploy should be set as default StorageClass
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed and setup to use the cluster
- [Helm](https://helm.sh/docs/intro/install/) 3 installed
- License File for Digital.ai Deploy in base64 encoded format
- Repository Keystorefile in base64 encoded format
- The passphrase for the RepositoryKeystore
