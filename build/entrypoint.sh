#!/bin/bash

function modify_relay_config() {
    key=${1}
    value=${2}
    if [ -z "${key}" ] || [ -z "${value}" ]; then
        echo "you have to set both key and value" && exit 1
    fi
    postconf -e "${key} = ${value}"
}

relayhost="[${MAILCOW_POSTFIX_IP:-172.22.1.253}]:${SMTPS_PORT}"

modify_relay_config "myhostname" "${MAILCOW_HOSTNAME}"
modify_relay_config "mydomain" "${MAILCOW_DOMAIN}"
modify_relay_config "relayhost" "${relayhost}"
modify_relay_config "mynetworks" "${MAILCOW_IPV4_NETWORK:-172.22.1.0/24} ${MAILCOW_IPV6_NETWORK:-fd4d:6169:6c63:6f77::/64} ${WG_NETWORK:-100.64.0}.0/24 127.0.0.0/8"
modify_relay_config "smtp_sasl_auth_enable" "yes"
modify_relay_config "smtp_sasl_security_options" "noanonymous"
modify_relay_config "smtp_sasl_password_maps" "lmdb:/etc/postfix/sasl_passwd"
modify_relay_config "smtp_use_tls" "yes"
modify_relay_config "smtp_host_lookup" "native,dns"
modify_relay_config "smtp_tls_wrappermode" "yes"
modify_relay_config "smtp_tls_security_level" "encrypt"
modify_relay_config "inet_protocols" "all"
modify_relay_config "maillog_file" "/var/log/postfix.log"

echo "${relayhost} ${SMTP_USERNAME}:${SMTP_PASSWORD}" > /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd

echo -e "[Interface]\nListenPort = 51820\nAddress = ${WG_NETWORK:-100.64.0}.1/24\nPrivateKey = ${WG_PRIVKEY}" > /etc/wireguard/wg0.conf
echo -e "[Peer]\nAllowedIPs = ${WG_NETWORK:-100.64.0}.2/24\nPublicKey = ${WG_CLIENT_PUBKEY}" >> /etc/wireguard/wg0.conf
wg-quick up wg0

exec /usr/sbin/postfix -c /etc/postfix start-fg
