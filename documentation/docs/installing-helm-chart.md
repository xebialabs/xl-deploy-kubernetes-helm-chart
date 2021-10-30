---
sidebar_position: 6
---

# Installing Helm Chart

Get the chart by cloning this repository:
```bash
git clone https://github.com/xebialabs/xl-deploy-kubernetes-helm-chart.git
```
The [Parameters](#parameters) section lists the parameters that can be configured before installation starts.
Before installing helm charts, you need to update the dependencies of a chart:
```bash
helm dependency update xl-deploy-kubernetes-helm-chart
```
To install the chart with the release name `xld-production`:
```bash
helm install xld-production xl-deploy-kubernetes-helm-chart
```
