command_exist() {
	type "$@" &> /dev/null
}

require_docker() {
	if ! command_exist docker; then
	  echo 'Docker command not found, aborting' >&2
	  exit 1
	fi
	
	if ! command_exist docker-compose; then
	  echo 'Docker-compose command not found, aborting' >&2
	  exit 1
	fi
}

common_init(){
	require_docker;
}