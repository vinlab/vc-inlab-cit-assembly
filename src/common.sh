command_exist() {
	type "$@" &> /dev/null
}

require_docker() {
	if ! command_exist docker; then
      echo 'CHECKING IF DOCKER COMMAND IS AVAILABLE>' >&2
	  echo 'Docker command not found, exiting.' >&2
	  exit 1
	fi
	
	if ! command_exist docker-compose; then
      echo 'CHECKING IF DOCKER COMPOSE COMMAND IS AVAILABLE>' >&2
	  echo 'Docker-compose command not found, exiting.' >&2
	  exit 1
	fi
}

require_docker_swarm() {
	if [ -z "`docker info | grep -F 'Swarm: active'`" ]; then
      echo 'CHECKING IF DOCKER SWARM IS AVAILABLE>' >&2
	  echo 'Docker swarm not found. Use "docker swarm init" (or "docker swarm join") to connect this node to swarm.' >&2
	  exit 1
	fi
}

require_this_node_in_docker_swarm() {
	if ! docker node ls &> /dev/null; then
      echo 'CHECKING WHETHER THIS NODE IS PART OF DOCKER SWARM>' >&2
      docker node ls  >&2
	  echo 'This node is not a swarm manager. Use "docker swarm init" (or "docker swarm join") to connect this node to swarm.' >&2
	  exit 1
	fi
}

startup_sequence(){
	require_docker;
	require_docker_swarm;
	require_this_node_in_docker_swarm;
}

common_init(){
	startup_sequence;
}