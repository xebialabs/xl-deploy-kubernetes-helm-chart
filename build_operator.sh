#!/bin/bash

containerOrganization="xldevdocker"

if [[ $# -eq 0 ]] ; then
    printf "\e[31mProvide in a first parameter a version (SemVer compatible) to release !\e[m\n"
    echo "For example:"
    printf "\e[1;32m./build_operator.sh 0.0.1\e[0m"
    exit 1
fi

if [[ $# -eq 2 ]] ; then
  containerOrganization=$2
fi

mkdir xld
cd xld
git clone git@github.com:xebialabs/xl-deploy-kubernetes-helm-chart.git
cd xl-deploy-kubernetes-helm-chart
rm -f values-haproxy.yaml
mv values-nginx.yaml values.yaml
helm dependency update .
rm -f Chart.lock
cd ..
helm package xl-deploy-kubernetes-helm-chart
rm -rf xl-deploy-kubernetes-helm-chart
mv digitalai-deploy-*.tgz xld.tgz
operator-sdk init --domain digital.ai --plugins=helm
operator-sdk create api --group=xld --version=v1alpha1 --helm-chart=xld.tgz
export OPERATOR_IMG="docker.io/$containerOrganization/deploy-operator:$1"
make docker-build docker-push IMG=$OPERATOR_IMG
cd ..
rm -rf xld
