docker-build:
	REPOSITORY=saracen9/postfix DOCKER_BUILD=true ./multi-arch.sh Dockerfile

docker-push:
	REPOSITORY=saracen9/postfix DOCKER_BUILD=false DOCKER_PUSH=true ./multi-arch.sh
