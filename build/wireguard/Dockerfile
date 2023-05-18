FROM alpine:3.18

LABEL "maintainer"="https://github.com/VoyNaLunu"
LABEL "version"="0.4"

WORKDIR /etc/wireguard

RUN apk update \
    && \
    apk add --no-cache \
    bash \
    wireguard-tools \
    net-tools \
    iptables \
    ip6tables \
    bind-tools \
    && \
    rm -rf /var/cache/apk/*

COPY . .

EXPOSE 51820

ENTRYPOINT [ "./entrypoint.sh" ]
