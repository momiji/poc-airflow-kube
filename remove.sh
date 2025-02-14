export NAMESPACE=example-namespace
export RELEASE_NAME=example-release

helm uninstall $RELEASE_NAME --namespace $NAMESPACE

kubectl delete namespace $NAMESPACE
