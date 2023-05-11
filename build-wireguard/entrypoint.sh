#!/bin/bash

if [ -z ${CLIENT_WG_PUBKEY} ]; then
    echo -e "Client private key:\n$(wg genkey | tee client-privatekey)"
    echo -e "Client's public key:\n$(cat client-privatekey | wg pubkey)"
    rm -f client-privatekey
    exit 0
fi


iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -t nat -A PREROUTING -i wg0 -p tcp --dport ${GATEWAY_SMTP_PORT:-25} -j DNAT --to-destination $(host gateway-postfix)

wg genkey | tee gateway-privatekey > /dev/null 2>&1
echo -e "Gateway's public key:\n$( cat gateway-privatekey | wg pubkey)"

echo -e "[Interface]\nListenPort = 51820\nAddress = ${GATEWAY_WG_NETWORK:-100.64.0}.1/24" > /etc/wireguard/wg0.conf
echo -e "PrivateKey = $(cat gateway-privatekey)" >> /etc/wireguard/wg0.conf
echo -e "[Peer]\nAllowedIPs = ${GATEWAY_WG_NETWORK:-100.64.0}.2/24\nPublicKey = ${CLIENT_WG_PUBKEY}" >> /etc/wireguard/wg0.conf
wg-quick up wg0
