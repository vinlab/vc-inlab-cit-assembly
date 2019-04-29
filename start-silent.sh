#!/bin/sh

# Run Code Inventory.
# Runs as a daemon. Use ./stop.sh to stop it.
from_dir=`pwd`
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${dir} || exit 1
source src/common.sh
common_init
docker stack up -c app.compose.yml code-inventory
wait_for_docker_stack_to_start
verify_app_containers_exist
cd ${from_dir} || exit 1
