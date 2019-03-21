#!/bin/sh

# Run Code Inventory.
# Runs as a daemon. Use ./stop.sh to stop it.
# TODO: verify docker-compose is available
FROM_DIR=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR}
docker-compose up -d
cd ${FROM_DIR}
