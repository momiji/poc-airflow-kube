FROM apache/airflow

# change user so we can install packages
USER root

# install additional packages: jq
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         jq \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# change user back to airflow
USER airflow
