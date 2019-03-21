#!/bin/sh

# Stop Code Inventory.
FROM_DIR=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR}
docker-compose down
cd ${FROM_DIR}
