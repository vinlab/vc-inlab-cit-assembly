#!/bin/sh

# Stop Code Inventory.
FROM_DIR=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR} || exit 1
#docker-compose down
docker stack down code-inventory
cd ${FROM_DIR} || exit 1
