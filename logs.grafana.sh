#!/bin/sh

# Follows Code Inventory Backend logs.
# Useful for verifying/troubleshooting.
from_dir=`pwd`
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${dir} || exit 1
source src/common.sh
common_init
wait_for_docker_stack_to_start
verfiy_app_containers_exist
docker logs -f "$(get_container_full_name 'code_inventory_backend-grafana')"
cd ${from_dir} || exit 1
