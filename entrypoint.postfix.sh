#!/bin/sh
envsubst < /etc/postfix/main.cf.template > /etc/postfix/main.cf

envsubst < /etc/dovecot/users.template > /etc/dovecot/users

rsyslogd

dovecot

postfix start-fg

tail -f /var/log/mail.log