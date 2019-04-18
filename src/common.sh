#!/bin/sh

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
      docker node ls  >&2
	  echo 'This node is not a swarm manager. Use "docker swarm init" to create a single-node swarm (or "docker swarm join" to connect to existing swarm.)' >&2
	  exit 1
	fi
}

docker_secret_exists(){
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

require_docker_secrets(){
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
	if ! $result; then
		echo 'Please re-install Code Inventory.' >&2
		exit 1
	fi
}

docker_container_exists(){
  # We do not use -w flag, to allow for checking by container infix
  # Example: docker_container_exists 'code_inventory_backend-'
  # will return true for both 'docker_code_inventory_backend-app_1'
  # as well as for 'code-inventory_code_inventory_backend-app.1.loe6skwa6i60jnqi4ja75723h'
  # (last name is specific to docker stack runs)
	docker container ls | grep --silent "$1"
}

require_app_not_running() {
  docker_container_exists 'code_inventory_backend-'
  # TODO: check if CIT is already running, prompt to stop
  if docker_container_exists 'code_inventory_backend-'; then
      echo 'CHECKING IF APPLICATION IS CURRENTLY RUNNING>' >&2
	  echo 'Code Inventory is currently running, cannot proceed.' >&2
	  exit 1
	fi
}

get_container_full_name(){
  docker container ls | grep "$1" | awk '{print $NF}'
}

startup_sequence(){
	require_docker
	require_docker_swarm
	require_master_password
	require_docker_secrets
  require_app_not_running
}

common_init(){
	startup_sequence
}
