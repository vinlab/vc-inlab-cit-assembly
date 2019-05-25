#!/bin/sh

# Stop Code Inventory.
from_dir=`pwd`
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${dir} || exit 1
source src/common.sh
echo "STOPPING ${APP}>"
docker stack down code-inventory
# Wait for containers to close, for the subsequent
# ./start to not to bump into 'app already running'
# check
for i in {0..5}; do
  sleep 5
  if ! docker_network_exists "code-inventory"; then
    break
  fi
  echo "Waiting..."
done
echo "STOPPING ${APP}>DONE"
cd ${from_dir} || exit 1
