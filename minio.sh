source env.sh --

docker run --rm -d --network host --name minio -e MINIO_ROOT_USER -e MINIO_ROOT_PASSWORD quay.io/minio/minio server /data --console-address ":9001"
