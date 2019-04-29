#!/bin/sh

# Stop Code Inventory.
from_dir=`pwd`
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${dir} || exit 1
docker stack down code-inventory
# Wait for containers to close, for the subsequent
# ./start to not to bump into 'app already running'
# check
sleep 11
cd ${from_dir} || exit 1
