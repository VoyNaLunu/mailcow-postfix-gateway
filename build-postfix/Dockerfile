FROM alpine:3.18

LABEL "maintainer"="https://github.com/VoyNaLunu"
LABEL "version"="0.3"

WORKDIR /app/

RUN echo "wireguard" >> /etc/modules \
    && \
    apk update \
    && \
    apk add --no-cache \
    bash \
    gawk \
    cyrus-sasl \
    cyrus-sasl-login \
    cyrus-sasl-crammd5 \
    mailx \
    postfix \
    wireguard-tools \
    && \
    rm -rf /var/cache/apk/*

COPY . .

EXPOSE 25

ENTRYPOINT [ "./entrypoint.sh" ]
