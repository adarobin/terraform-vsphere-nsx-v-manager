#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
# set -o xtrace

resp=""
rmqstatus=""
vpgstatus=""
mgrstatus=""

while true; do
    resp=`curl --silent --insecure --user "${NSXV_USERNAME}:${NSXV_PASSWORD}" --header 'Accept: application/json' https://${NSXV_MANAGER_HOSTNAME}/api/1.0/appliance-management/summary/components` || true
    rmqstatus=`echo $resp | jq -r '.componentsByGroup.COMMON.components[] | select (.componentId == "RABBITMQ") | .status'` || true
    vpgstatus=`echo $resp | jq -r '.componentsByGroup.COMMON.components[] | select (.componentId == "VPOSTGRES") | .status'` || true
    mgrstatus=`echo $resp | jq -r '.componentsByGroup.NSXGRP.components[] | select (.componentId == "NSX") | .status'` || true

    if [ "$rmqstatus" = "RUNNING" ] && [ "$vpgstatus" = "RUNNING" ] && [ "$mgrstatus" = "RUNNING" ]; then
        echo "NSX-V Manager is started successfully."
        break
    fi

    echo "RabbitMQ status was $rmqstatus, vPostgres status was $vpgstatus, and Manager status was $mgrstatus. Sleeping for 20 seconds."
    sleep 20
done

exit 0
