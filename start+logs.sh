#!/bin/sh

# Run Code Inventory, display logs on screen.
# Useful for verifying/troubleshooting.
# TODO: verify docker-compose is available
FROM_DIR=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR}
docker-compose up
cd ${FROM_DIR}
