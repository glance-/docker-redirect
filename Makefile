all: build push
build:
	docker build --no-cache=true -t redirect .
	docker tag -f ac-frontend docker.sunet.se/redirect
push:
	docker push docker.sunet.se/redirect
