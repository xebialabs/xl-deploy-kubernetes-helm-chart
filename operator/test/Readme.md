
# Certified Operator Installation

Install operator from Openshift admin console: Operator > OperatorHub, search for `Digital.ai`.
Select Deploy operator and press `Install` button.

It will create from catalog source `openshift-operators`:
- install plan
- subscription
- CSV 

## Check Result

```shell
oc get sub -n openshift-operators
oc get installplan -n openshift-operators
oc get csv
```

```shell
oc describe csv 
```

```shell
oc get pods -n openshift-operators
```

## Create Deploy release

```shell
oc create -n deploy-test-operator -f ../config/samples/xld_minimal.yaml
```

# Local Operator Installation

## Installing the opm CLI

Check [Installing the opm CLI](https://docs.openshift.com/container-platform/4.15/cli_reference/opm/cli-opm-install.html)

## References

- [Deploying onto OpenShift](https://redhat-connect.gitbook.io/certified-operator-guide/ocp-deployment/openshift-deployment)

## Creating an index image

```shell
opm index add \
  --bundles docker.io/xebialabsunsupported/deploy-operator-bundle:24.1.2-rc.6-redhat \
  --tag docker.io/xebialabsunsupported/deploy-operator-index:latest \
  --generate
```

```shell
docker build -f index.Dockerfile -t docker.io/xebialabsunsupported/deploy-operator-index:latest .
```

```shell
docker push docker.io/xebialabsunsupported/deploy-operator-index:latest
```

## Create the CatalogSource

```shell
oc create -f test-operator-catalogsource.yaml 
oc -n openshift-marketplace get catalogsource
oc -n openshift-marketplace get pods
```

```shell
oc -n openshift-marketplace get catalogsource | grep test-operators
oc -n openshift-marketplace get pods | grep test-operators
oc get packagemanifests | grep "Test Operators"
```

## Create OperatorGroup

```shell
oc new-project deploy-test-operator
```

```shell
oc delete operatorgroup deploy-test-group -n deploy-test-operator
```

```shell
oc create -f test-operatorgroup.yaml
```

```shell
oc get operatorgroup
```

## Create a Subscription

```shell
oc delete sub deploy-test-subscription -n deploy-test-operator
```

```shell
oc create -f test-subscription.yaml
```

```shell
oc get sub -n deploy-test-operator
oc get installplan -n deploy-test-operator
oc get csv -n deploy-test-operator
```

## Check Result

```shell
oc describe csv -n deploy-test-operator
```

```shell
oc get pods -n deploy-test-operator
```

```shell
oc create -n deploy-test-operator -f ../config/samples/xld_minimal.yaml
```

## Upgrade an existing image

```shell
opm index add \
  --bundles docker.io/xebialabsunsupported/deploy-operator-bundle:24.1.2-rc.5-redhat \
  --from-index docker.io/xebialabsunsupported/deploy-operator-index:latest \
  --tag docker.io/xebialabsunsupported/deploy-operator-index:latest \
  --generate
```

```shell
docker build -f index.Dockerfile -t docker.io/xebialabsunsupported/deploy-operator-index:latest .
```

```shell
docker push docker.io/xebialabsunsupported/deploy-operator-index:latest
```
