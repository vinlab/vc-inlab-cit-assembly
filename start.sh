#!/bin/sh

# Run Code Inventory.
# Runs as a daemon. Use ./stop.sh to stop it.
FROM_DIR=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR} || exit 1
source src/common.sh
common_init
#docker-compose up -d
docker stack up -c docker-compose.yml code-inventory
cd ${FROM_DIR} || exit 1
