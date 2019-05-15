#!/bin/sh

# Run only the infrastructure part of Code Inventory
# Useful for troubleshooting, if you want to start
# Code Inventory application containers separately.
# Starts Postgres and Grafana containers only.
# Use ./stop.sh to stop it.
from_dir=`pwd`
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${dir} || exit 1
source src/common.sh

startup_prompt() {
  if ! prompt_Yn "
    This will start ${App} dependency services - database, grafana - without starting ${App} application itself." "
    Proceed? (Y/n) "; then
    exit 0
  fi
}

common_start_script_init
# Script is called from Code Inventory Installer, where this prompt creates confusion
#startup_prompt
echo "STARTING ${APP} APPLICATION>"
docker stack up -c infra.compose.yml code-inventory
wait_for_docker_stack_to_start
echo "POSTGRES LOGS:"
docker logs --tail all "$(get_container_full_name 'code_inventory_backend-postgres')"
echo "STARTING ${APP} INFRASTRUCTURE>DONE"
cd ${from_dir} || exit 1
