source env.sh --

helm uninstall "$RELEASE_NAME "--namespace "$NAMESPACE"

kubectl delete namespace "$NAMESPACE"
