#!/bin/bash

if [ -z ${CLIENT_WG_PUBKEY} ]; then
    echo -e "Client's private key, use it on your client system:\n$(wg genkey | tee client-privatekey)\n"
    echo -e "Client's public key, add this to your .env file:\nCLIENT_WG_PUBKEY='$(cat client-privatekey | wg pubkey)'\n"
    rm -f client-privatekey
    exit 0
fi

if [ ! -s /etc/wireguard/wg0.conf ]; then
    wg genkey | tee gateway-privatekey > /dev/null 2>&1
    echo -e "Gateway's public key:\n$( cat gateway-privatekey | wg pubkey)\n"
    chmod 600 gateway-privatekey


    echo -e "[Interface]\nListenPort = 51820\nAddress = ${GATEWAY_WG_NETWORK:-100.64.0}.1/24" > /etc/wireguard/wg0.conf
    echo -e "PrivateKey = $(cat gateway-privatekey)" >> /etc/wireguard/wg0.conf
    echo -e "[Peer]\nAllowedIPs = ${GATEWAY_WG_NETWORK:-100.64.0}.0/24\nPublicKey = ${CLIENT_WG_PUBKEY}" >> /etc/wireguard/wg0.conf
    chmod 700 /etc/wireguard/wg0.conf
fi

wg-quick up wg0 && echo -e "\n"

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -t nat -A PREROUTING -i wg0 -p tcp --dport ${GATEWAY_SMTP_PORT:-25} -j DNAT --to-destination $(dig +short gateway-postfix):25

wg && echo -e "\n"

while true
do
    wg=$(wg)
    if [ -z "${wg}" ]; then
        echo "something went wrong"
        exit 1
    fi
    sleep 1
done
