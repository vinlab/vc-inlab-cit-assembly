#!/bin/sh

# Run Code Inventory.
# Runs as a daemon. Use ./stop.sh to stop it.
FROM_DIR=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR}
source src/common.sh
common_init
docker-compose up -d
cd ${FROM_DIR}
