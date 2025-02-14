export NAMESPACE=example-namespace
kubectl create namespace "$NAMESPACE"

export RELEASE_NAME=example-release

export CHART_VERSION=1.15.0

helm install "$RELEASE_NAME" apache-airflow/airflow \
  --version "$CHART_VERSION" \
  --namespace "$NAMESPACE" \
  --set-string "env[0].name=AIRFLOW__CORE__LOAD_EXAMPLES" \
  --set-string "env[0].value=True" \
  --values values.yaml
