docker run --rm -d --network host --name minio -e MINIO_ROOT_USER=admin -e MINIO_ROOT_PASSWORD=admin123 quay.io/minio/minio server /data --console-address ":9001"
