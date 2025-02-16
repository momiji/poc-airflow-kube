source env.sh --

helm template "$RELEASE_NAME" apache-airflow/airflow \
  --version "$CHART_VERSION" \
  --namespace "$NAMESPACE" \
  --set-string "env[0].name=AIRFLOW__CORE__LOAD_EXAMPLES" \
  --set-string "env[0].value=True" \
  --values values.yaml
