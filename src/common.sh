#!/bin/sh
#
# Code Inventory Assembly
#
# Implements logic for use in Code Inventory start/stop scripts.
#
# Author: Andrey Potekhin
#

source src/constants.sh

command_exist() {
  type "$@" &> /dev/null
}

require_docker() {
  if ! command_exist docker; then
    echo 'CHECKING IF DOCKER COMMAND IS AVAILABLE>' >&2
    echo 'Docker command not found, you need to install Docker first. Exiting.' >&2
    exit 1
  fi
  if ! command_exist docker-compose; then
    echo 'CHECKING IF DOCKER COMPOSE COMMAND IS AVAILABLE>' >&2
    echo 'Docker-compose command not found, exiting.' >&2
    exit 1
  fi
}

require_docker_swarm() {
  if [ -z "`docker info | grep -F 'Swarm:'`" ]; then
    echo 'CHECKING IF DOCKER SWARM IS AVAILABLE>' >&2
    echo 'Docker swarm not found. Use "docker swarm init" to create a single-node swarm (or "docker swarm join" to connect to existing swarm.)' >&2
    exit 1
  fi
  if [ -z "`docker info | grep -F 'Swarm: active'`" ]; then
    echo 'CHECKING IF DOCKER SWARM IS ACTIVE>' >&2
    echo 'Docker swarm not active. Use "docker swarm init" to activate a single-node swarm (or "docker swarm join" to connect to existing swarm.)' >&2
    exit 1
  fi
  if ! docker node ls &> /dev/null; then
    echo 'CHECKING WHETHER THIS NODE IS PART OF DOCKER SWARM>' >&2
    docker node ls >&2
    echo 'This node is not a swarm manager. Use "docker swarm init" to create a single-node swarm (or "docker swarm join" to connect to existing swarm.)' >&2
    exit 1
  fi
}

docker_secret_exists() {
  if docker secret ls | grep -w "$1" &> /dev/null; then
    true
  else
    false
  fi
}

require_master_password() {
  if ! docker_secret_exists 'code-inventory-master-password'; then
    echo 'CHECKING IF MASTER PASSWORD EXISTS>' >&2
    echo 'Master password not found, please re-run Code Inventory install script.' >&2
    exit 1
  fi
}

require_docker_secrets() {
  result=true
  if ! docker_secret_exists 'code-inventory-db-backend-password'; then
    echo 'CHECKING DOCKER SECRETS>' >&2
    echo 'Missing docker secret: code-inventory-db-backend-password' >&2
    result=false
  fi
  if ! docker_secret_exists 'code-inventory-db-postgres-password'; then
    echo 'CHECKING DOCKER SECRETS>' >&2
    echo 'Missing docker secret: code-inventory-db-postgres-password' >&2
    result=false
  fi
  if ! docker_secret_exists 'code-inventory-db-grafana-password'; then
    echo 'CHECKING DOCKER SECRETS>' >&2
    echo 'Missing docker secret: code-inventory-db-grafana-password' >&2
    result=false
  fi
  if ! ${result}; then
    echo 'Please re-install Code Inventory.' >&2
    exit 1
  fi
}

docker_container_exists() {
  # We do not use -w flag, to allow for checking by container infix
  # Example: docker_container_exists 'code_inventory_backend-app'
  # will return true for both 'docker_code_inventory_backend-app_1'
  # as well as for 'code-inventory_code_inventory_backend-app.1.loe6skwa6i60jnqi4ja75723h'
  # (last name is specific to docker stack runs)
  docker container ls | grep --silent "$1"
}

require_app_not_running() {
  if docker_container_exists 'code_inventory_backend-app'; then
    echo 'CHECKING IF APPLICATION IS CURRENTLY RUNNING>' >&2
    echo 'Code Inventory is already running.' >&2
    exit 1
  fi
}

get_container_full_name() {
  docker container ls | grep "$1" | awk '{print $NF}'
}

get_container_full_name1() {
  docker container ls | grep "$1" | awk '{print $NF}'
}

docker_image_exists() {
  # We do not use -w flag, to allow for checking by container infix
  # Example: docker_image_exists 'code_inventory_backend'
  # will return true for both 'vinlab/code_inventory_backend:latest'
  # as well as for 'vinlab/code_inventory_backend:1.0.1'
  docker image ls  --format '{{.Repository}}:{{.Tag}}' | grep --silent "$1"
}

require_app_docker_image() {
  if ! docker_image_exists "$1"; then
    echo 'CHECKING REQUIRED DOCKER IMAGES>' >&2
    echo "Missing required docker image: $1. Please reinstall Code Inventory." >&2
    exit 1
  else
    true
  fi
}

require_app_docker_images() {
  require_app_docker_image ${BACKEND_DOCKER_IMAGE} \
  && require_app_docker_image ${POSTGRES_DOCKER_IMAGE} \
  && require_app_docker_image ${GRAFANA_DOCKER_IMAGE}
#  && require_app_docker_image ${FRONTEND_DOCKER_IMAGE}
}

create_dir_if_missing() {
	if ! [ -d "$2" ]; then
    echo 'CHECKING FOR MISSING DIRS>' >&2
		echo "Missing $1 dir, creating"
		mkdir -p "$2"
	fi
}

create_any_missing_dirs() {
  if ! create_dir_if_missing "postgres data" "${postgres_dir}" \
  || ! create_dir_if_missing "code" "${code_dir}" \
  || ! create_dir_if_missing "jobs" "${jobs_dir}" \
  || ! create_dir_if_missing "grafana" "${grafana_dir}" \
  || ! create_dir_if_missing "grafana data" "${grafana_dir}/data"
  then
    echo "${APP} INSTALLATION HAS FAILED"
    exit 1
  fi
}

startup_sequence() {
  require_docker
  require_docker_swarm
  require_master_password
  require_docker_secrets
  require_app_docker_images
}

common_init() {
  startup_sequence
}

common_start_script_init() {
  common_init
  require_app_not_running
  create_any_missing_dirs
}

wait_for_docker_stack_to_start(){
  lib/docker-stack-wait/docker-stack-wait.sh -t 10 code-inventory
}

verify_app_container_exist() {
  app_container=$(get_container_full_name $2)
  if [ -z "${app_container}" ]; then
    echo 'VERIFYING APPLICATION IS RUNNING>' >&2
    echo "Error: Not found: application's $1 container: $2" >&2
    # Show any errors from service startup - they will not be shown in container logs,
    # since the container was not created yet (issue 176)
    echo "Checking application's $1 service processes. Please make note of any errors:" >&2
    docker service ps --no-trunc "$3"
    false
  else
    true
  fi
}

verfiy_app_containers_exist() {
  if ! verify_app_container_exist 'backend' 'code_inventory_backend-app' 'code-inventory_code_inventory_backend-app' \
  || ! verify_app_container_exist 'postgres' 'code_inventory_backend-postgresql' 'code-inventory_code_inventory_backend-postgresql' \
  || ! verify_app_container_exist 'backend' 'code_inventory_backend-grafana' 'code-inventory_code_inventory_backend-grafana'
  then
    exit 1
  fi
}
