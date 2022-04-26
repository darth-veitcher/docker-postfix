#!/bin/bash
set -e

# Set up hostname and domain
postconf -e "myhostname=$POSTFIX_HOSTNAME"

if [ -Z $POSTFIX_DOMAIN ]; then
    HOST=$(echo $POSTFIX_HOSTNAME | cut -d '.' -f 1)
    POSTFIX_DOMAIN=$(echo $POSTFIX_HOSTNAME | sed -r 's/'$HOST'.//')
fi

postconf -e "mydomain=$POSTFIX_DOMAIN"

# Disable SMTPUTF8, because libraries (ICU) are missing in Alpine
postconf -e "smtputf8_enable=no"

# Log to stdout
postconf -e "maillog_file=/dev/stdout"

# Update aliases database. It's not used, but postfix complains if the .db file is missing
postalias /etc/postfix/aliases

# Configure mail delivery
postconf -e "mydestination=\$myhostname, localhost.\$mydomain, localhost, \$mydomain, mail.\$mydomain"
postconf -e "myorigin=\$mydomain"

# Limit message size to 10MB
postconf -e "message_size_limit=10240000"

# Reject invalid HELOs
postconf -e "smtpd_delay_reject=yes"
postconf -e "smtpd_helo_required=yes"
postconf -e "smtpd_helo_restrictions=permit_mynetworks,reject_invalid_helo_hostname,permit"

# Allow requests from any private network we are attached to
postconf -e "mynetworks=127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 224.0.0.0/4"

# Do not relay mail from untrusted networks
postconf -e "relay_domains="

# Use 587 (submission)
sed -i -r -e 's/^#submission/submission/' /etc/postfix/master.cf

echo
echo 'postfix configured. Ready for start up.'
echo

exec "$@"