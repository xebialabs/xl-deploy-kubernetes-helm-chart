---
sidebar_position: 5
---

:::caution
This is internal documentation. This document can be used only if it was recommended by the Support Team.
:::

# Installing Storage Class
 If you are using storage class other than NFS and EFS then please proceed with installation steps
## NFS Client Provisioner for On-Premises Kubernetes cluster
* For deploying helm chart, `nfs server` and `nfs mount path` are required.
* Before installing NFS Provisioner helm chart, you need to add the stable helm repository to your helm client as shown below:
```bash
helm repo add stable https://charts.helm.sh/stable
```
* To install the chart with the release name `nfs-provisioner`:
```bash
helm install nfs-provisioner --set nfs.server=x.x.x.x --set nfs.path=/exported/path stable/nfs-client-provisioner
```
* The `nfs-provisioner` storage class must be marked with the default annotation so that PersistentVolumeClaim objects (without a StorageClass specified) will trigger dynamic provisioning.
```bash
kubectl patch storageclass nfs-client -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```
* After deploying the nfs helm chart, execute the below command to get StorageClass name which can be used in values.yaml file for parameter `Persistence.StorageClass`
```bash
kubectl get storageclass
```
For more information on nfs-client-provisioner, refer [stable/nfs-client-provisioner](https://github.com/helm/charts/tree/master/stable/nfs-client-provisioner)
## Elastic File System for AWS Elastic Kubernetes Service(EKS) cluster 
Before deploying EFS helm chart, there are some steps which need to be performed.
* Create your EFS file system. Refer [Create Your Amazon EFS File System](https://docs.aws.amazon.com/efs/latest/ug/gs-step-two-create-efs-resources.html) for creating file system.
* Create a mount target. Refer [Creating mount targets](https://docs.aws.amazon.com/efs/latest/ug/accessing-fs.html) for creating mount target.
* Before installing EFS Provisioner helm chart, you need to add the stable helm repository to your helm client as shown below:
```bash
helm repo add stable https://charts.helm.sh/stable
```
* Provide the `efsFileSystemId` and `awsRegion` which can be obtained by executing above steps. Install the chart with the release name `aws-efs`:
```bash
helm install aws-efs stable/efs-provisioner --set efsProvisioner.efsFileSystemId=fs-12345678 --set efsProvisioner.awsRegion=us-east-2
```
* The `aws-efs` storage class must be marked with the default annotation so that PersistentVolumeClaim objects (without a StorageClass specified) will trigger dynamic provisioning.
```bash
kubectl patch storageclass aws-efs -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```
* There has to be only one storage class with default setting, so remove other storage classes with default settings.
```bash
kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
```
* After deploying the efs helm chart, execute the below command to get StorageClass name which can be used in values.yaml file for parameter `Persistence.StorageClass`
```bash
kubectl get storageclass
```
For more information on efs-provisioner, refer [stable/efs-provisioner](https://github.com/helm/charts/tree/master/stable/efs-provisioner)
