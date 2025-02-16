source env.sh --

kubectl exec -n "$NAMESPACE" -t -c webserver "deployment/$RELEASE_NAME-webserver" -- "$@"
