FROM minio/minio

ADD ./docker/prod/s3/config.json /root/.minio/config.json

CMD ["--address", ":80", "/data"]