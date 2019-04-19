#!/bin/sh

# Stop Code Inventory.
FROM_DIR=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR} || exit 1
#docker-compose down
docker stack down code-inventory
# Wait for containers to close, for the subsequent
# ./start to not to bump into 'app already running'
# check
sleep 6
cd ${FROM_DIR} || exit 1
