#!/bin/sh

# Run only the infrastructure part of Code Inventory
# Useful for troubleshooting, if you want to start
# Code Inventory application containers separately.
# Starts Postgres and Grafana containers only.
# Use ./stop.sh to stop it.
FROM_DIR=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR} || exit 1
source src/common.sh
common_init
docker stack up -c infra.compose.yml code-inventory
cd ${FROM_DIR} || exit 1
