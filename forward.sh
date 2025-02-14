export NAMESPACE=example-namespace
export RELEASE_NAME=example-release

kubectl port-forward svc/$RELEASE_NAME-webserver 8080:8080 --namespace $NAMESPACE
