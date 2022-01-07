#!/bin/bash

containerOrganization="xldevdocker"
upgrade="false"

if [[ $# -eq 0 ]] ; then
    printf "\e[31mProvide in a first parameter a version (SemVer compatible) to release !\e[m\n"
    echo "For example:"
    printf "\e[1;32m./build_operator.sh 0.0.1\e[0m"
    exit 1
fi

if [[ $# > 1 ]] ; then
  containerOrganization=$2
fi

export OPERATOR_IMG="docker.io/$containerOrganization/deploy-operator:$1"

if [[ $# > 2 ]] ; then
  if [[ "$3" == "true" ]] ; then
    upgrade="true"
fi
fi

#mkdir xld
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
make docker-build docker-push IMG=$OPERATOR_IMG

export IMG=$OPERATOR_IMG
echo "IMG=$OPERATOR_IMG"

export USERNAME=$containerOrganization
echo "USERNAME=$containerOrganization"

export VERSION=$1
echo "VERSION=$1"

export BUNDLE_IMG=docker.io/$USERNAME/deploy-operator-bundle:$VERSION

echo "BUNDLE_IMG=docker.io/$USERNAME/deploy-operator-bundle:$VERSION"

operator-sdk olm install

echo "make bundle"
make bundle

echo "make bundle-build bundle-push"
make bundle-build bundle-push

echo "operator-sdk bundle validate $BUNDLE_IMG"
operator-sdk bundle validate $BUNDLE_IMG

if [[ "$upgrade" == "true" ]] ; then
  echo "operator-sdk run bundle-upgrade $BUNDLE_IMG"
  operator-sdk run bundle-upgrade $BUNDLE_IMG --timeout 10m0s
else
  echo "operator-sdk run bundle $BUNDLE_IMG"
  operator-sdk run bundle $BUNDLE_IMG --timeout 10m0s
fi

#cd ..
#rm -rf xld
