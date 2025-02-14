## Installation

### minikube

Installer un cluster minikube avec les addons metrics-server et yakd.

```bash
$ minikube start
```
```
😄  minikube v1.35.0 on Ubuntu 24.04
✨  Automatically selected the docker driver
📌  Using Docker driver with root privileges
👍  Starting "minikube" primary control-plane node in "minikube" cluster
🚜  Pulling base image v0.0.46 ...
🔥  Creating docker container (CPUs=8, Memory=8192MB) ...
🐳  Preparing Kubernetes v1.32.0 on Docker 27.4.1 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔗  Configuring bridge CNI (Container Networking Interface) ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

```bash
$ kubectl get pods -A
```
```
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-668d6bf9bc-rt7tz           1/1     Running   0          54s
kube-system   etcd-minikube                      1/1     Running   0          60s
kube-system   kube-apiserver-minikube            1/1     Running   0          59s
kube-system   kube-controller-manager-minikube   1/1     Running   0          59s
kube-system   kube-proxy-xcjtn                   1/1     Running   0          54s
kube-system   kube-scheduler-minikube            1/1     Running   0          59s
kube-system   storage-provisioner                1/1     Running   0          58s
```

```bash
minikube addons enable metrics-server
minikube addons enable yakd
```

### airflow

helm repo add apache-airflow https://airflow.apache.org
helm repo update


```bash
$ ./install.sh
```
```
namespace/example-namespace created
NAME: example-release
LAST DEPLOYED: Thu Feb 13 22:54:06 2025
NAMESPACE: example-namespace
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Thank you for installing Apache Airflow 2.9.3!

Your release is named example-release.
You can now access your dashboard(s) by executing the following command(s) and visiting the corresponding port at localhost in your browser:

Airflow Webserver:     kubectl port-forward svc/example-release-webserver 8080:8080 --namespace example-namespace
Default Webserver (Airflow UI) Login credentials:
    username: admin
    password: admin
Default Postgres connection credentials:
    username: postgres
    password: postgres
    port: 5432

You can get Fernet Key value by running the following:

    echo Fernet Key: $(kubectl get secret --namespace example-namespace example-release-fernet-key -o jsonpath="{.data.fernet-key}" | base64 --decode)
```

### minio

Hors kube ce qui permet de l'utiliser directement.

```bash
$ ./minio.sh
```
```bash
$ export MC_HOST_x=http://admin:admin123@192.168.49.1:9000
$ mc mb x/logs
``` 
``` 
Bucket created successfully `x/logs`.
``` 

### forwarding

```bash
$ ./forward.sh
``` 

=> http://localhost:8080

## Configuration

### logs

Objectif: écrire les logs dans s3 pour les conserver après la destruction des pods.

https://airflow.apache.org/docs/apache-airflow/stable/configurations-ref.html#remote-logging
https://airflow.apache.org/docs/apache-airflow-providers-amazon/stable/logging/s3-task-handler.html

La configuration dans `values.yaml` utilise le bucket `s3://logs` et la connexion `logs` qui doit être créée:

- Menu Admin > Connections
- Créer une nouvelle connection
    - Id: `logs`
    - Type: `Amazon Web Services`
    - Access Key: `admin`
    - Secret Access Key: `admin123`
    - Extra: `{"endpoint_url": "http://192.168.49.1:9000"}`

Pour tester que ça fonctionne, il faut simplement démarrer manuellement `example_bash_operator` dans airflow et vérifier que les fichiers apparaiswent dans minio.

```bash
$ mc find x/logs/
x/logs/dag_id=example_bash_operator/run_id=scheduled__2025-02-12T00:00:00+00:00/task_id=also_run_this/attempt=1.log
x/logs/dag_id=example_bash_operator/run_id=scheduled__2025-02-12T00:00:00+00:00/task_id=runme_0/attempt=1.log
x/logs/dag_id=example_bash_operator/run_id=scheduled__2025-02-12T00:00:00+00:00/task_id=runme_1/attempt=1.log
x/logs/dag_id=example_bash_operator/run_id=scheduled__2025-02-12T00:00:00+00:00/task_id=runme_2/attempt=1.log
x/logs/dag_id=example_bash_operator/run_id=scheduled__2025-02-12T00:00:00+00:00/task_id=this_will_skip/attempt=1.log
```

### droits

Objectif: simuler les accès d'un analyste qui peut démarrer certaines tâches.

https://airflow.apache.org/docs/apache-airflow-providers-fab/stable/auth-manager/access-control.html

- Menu Security > List Roles
- Créer un nouveau rôle
    - Name: `analyst`
    - Permissions: laisser vide
- Ajouter un utilisateur:
    - Name: `ba`
    - Role: `analyst`
