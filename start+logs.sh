#!/bin/sh

# Run Code Inventory, display logs on screen.
# Useful for verifying/troubleshooting.
FROM_DIR=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR}
source src/common.sh
common_init
docker-compose up
cd ${FROM_DIR}
