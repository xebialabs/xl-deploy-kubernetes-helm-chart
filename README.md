# xl-deploy-kubernetes-helm-chart
Kubernetes Helm chart for XL Deploy


# Overview

This repository contains a Helm Chart for Xebialabs Deploy (XL Deploy) product.  This is meant to help you deploy to your kubernetes cluster more quickly and efficiently.


# Usage

In short, the repository contains the files for your *helm* operations.

1. Get the chart by cloning this repository:

```
git clone git@github.com:xebialabs/xl-deploy-kubernetes-helm-chart.git
```

2. Install the chart onto your cluster with the name "xld"
```
helm install -n xld xl-deploy-kubernetes-helm-chart
```

3. Get the pod for your newly released software:

```
kubectl get pods
```

Remember the name of pod and use it in the next command.

4. (optional) Given the pod name, watch the logs in your terminal:

```
kubectl logs -f xld-xl-deploy-fancypodname
```

Watch for the  generated admin password at the top of the logs
Wait until the logs indicates PreArchiveService has started.

5. Setup ports for your team's access

```
kubectl port-forward svc/xld-xl-deploy 4516:80
```

+ Go to a browser and navigate to http://localhost:4516
+ Paste the license key that Fang sent into the textbox and click the “Install license” button
+ Click the “Get started” button.
+ Log in with the username admin and the password that you captured from the logs earlier on.
 


