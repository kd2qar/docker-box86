TAG=kd2qar/box86
NAME=box86

HOSTNAME="box86"

VOLUMES=-v /var/run/docker.sock:/var/run/docker.sock 

ARGS= ${VOLUMES}

All: Build

Build:
	docker  build --rm --tag ${TAG} .

run:  Build remove
	docker run -d --shm-size="1g"  ${ARGS} --hostname="${HOSTNAME}" --name ${NAME} ${TAG}

shell: Build
	docker run --rm -it --name ${NAME}_shell ${TAG} /bin/bash

stop:
	@docker stop ${NAME} 2>/dev/null | true;

remove: stop
	@docker rm ${NAME} 2>/dev/null | true;

