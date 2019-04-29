#!/bin/sh

# Run Code Inventory, display logs down to TRACE level
# Useful for verifying/troubleshooting.
from_dir=`pwd`
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${dir} || exit 1
source src/common.sh
common_init
docker stack up -c app.compose.yml code-inventory
wait_for_docker_stack_to_start
verify_app_containers_exist
docker logs -f "$(get_container_full_name 'code_inventory_backend-app')"
cd ${from_dir} || exit 1
