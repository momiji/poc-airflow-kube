./exec.sh airflow roles list -p -o json | jq '.[] | . as $r | $r.action | split(",")[] | [$r.name,$r.resource,.] | join("|")' -rc | sort
