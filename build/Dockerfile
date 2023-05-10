FROM alpine:3.18

LABEL "maintainer"="https://github.com/VoyNaLunu"
LABEL "version"="0.1"

WORKDIR /app/
COPY . .
RUN apk update && \
    apk add --no-cache bash gawk cyrus-sasl cyrus-sasl-login cyrus-sasl-crammd5 mailx \
    postfix && \
    rm -rf /var/cache/apk/* && \
    chmod +x ./entrypoint.sh

EXPOSE 25

ENTRYPOINT [ "./entrypoint.sh" ]