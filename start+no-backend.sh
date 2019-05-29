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
    This will start ${App} database, grafana, frontend without starting ${App} backend." "
    Proceed? (Y/n) "; then
    exit 0
  fi
}

common_start_script_init
startup_prompt
echo "STARTING ${APP} BACKENDLESS>"
docker stack up -c backendless.compose.yml code-inventory
wait_for_docker_stack_to_start
echo "STARTING ${APP} BACKENDLESS>DONE"
cd ${from_dir} || exit 1
