#!/bin/sh

# Run Code Inventory, display logs down to TRACE level
# Useful for verifying/troubleshooting.
FROM_DIR=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR} || exit 1
source src/common.sh
common_init
docker stack up -c app.compose.yml code-inventory
sleep 6
docker logs -f "$(get_container_full_name 'code_inventory_backend-app')"
cd ${FROM_DIR} || exit 1
