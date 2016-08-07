FROM dockercloud/haproxy

COPY ./docker/prod/proxy/eventhandler.py /haproxy-src/haproxy

RUN apk update && \
    apk --no-cache add tini haproxy py-pip build-base python-dev ca-certificates && \
    cp /haproxy-src/reload.sh /reload.sh && \
    cd /haproxy-src && \
    pip uninstall -y dockercloud-haproxy && \
    pip install -r requirements.txt && \
    pip install . && \
    apk del build-base python-dev && \
    rm -rf "/tmp/*" "/root/.cache" `find / -regex '.*\.py[co]'`