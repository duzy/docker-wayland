build:
	docker build --rm=true --tag weston-yakkety .
	docker rmi $$(docker images | grep '<none>' | awk '{print $$3}') \
	  2>/dev/null || true

.PHONY: build
