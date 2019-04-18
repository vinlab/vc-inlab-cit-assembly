#!/bin/sh

# Run Code Inventory, display logs on screen.
# Useful for verifying/troubleshooting.
FROM_DIR=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR} || exit 1
source src/common.sh
common_init
#docker-compose up
docker stack up -c docker-compose.yml code-inventory
# tail logs
sleep 6
container_name=$(get_container_full_name 'code_inventory_backend-app')
echo "Backend app container: ${container_name}"
docker logs -f "${container_name}"
cd ${FROM_DIR} || exit 1
