#!/bin/sh

if [ -f .env ]; then
    smtp_host=$(grep "^SMTP_HOST=" .env | cut -d '=' -f2-)
    smtp_port=$(grep "^SMTP_PORT=" .env | cut -d '=' -f2-)
    smtp_test_from=$(grep "^SMTP_TEST_FROM=" .env | cut -d '=' -f2-)
    smtp_test_to=$(grep "^SMTP_TEST_TO=" .env | cut -d '=' -f2-)
    postfix_user=$(grep "^POSTFIX_USER=" .env | cut -d '=' -f2-)
    postfix_password=$(grep "^POSTFIX_PASSWORD=" .env | cut -d '=' -f2-)
else
    if [ -z "${SMTP_HOST}" ] || \
        [ -z "${SMTP_PORT}" ] || \
        [ -z "${SMTP_TEST_FROM}" ] || \
        [ -z "${SMTP_TEST_TO}" ] || \
        [ -z "${POSTFIX_USER}" ] || \
        [ -z "${POSTFIX_PASSWORD}" ]; then
        echo "Error: Environment variables are not set and .env file is missing."
    else
        smtp_host="${SMTP_HOST}"
        smtp_port="${SMTP_PORT}"
        smtp_test_from="${SMTP_TEST_FROM}"
        smtp_test_to="${SMTP_TEST_TO}"
        postfix_user="${POSTFIX_USER}"
        postfix_password="${POSTFIX_PASSWORD}"

    fi
fi

swaks --auth \
        --server "${smtp_host}" \
        --port "${smtp_port}" \
        --au "${postfix_user}" \
        --ap "${postfix_password}" \
        --from "${smtp_test_from}" \
        --to "${smtp_test_to}" \
        --h-Subject: "Direct Test at $(date +'%d-%m-%Y %H:%M:%S')" \
        --body 'Testing direct SMTP delivery!' \
        --tls

