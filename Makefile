NAME ?= sqwatchio/payment

INSTANCE = payment

.PHONY: default copy test

default: test

copy:
	docker create --name $(INSTANCE) $(NAME)-dev
	docker cp $(INSTANCE):/app $(shell pwd)/app
	docker rm $(INSTANCE)

release: BUILDER ?= minikube image
release: TAG ?= latest
release:
	$(BUILDER) build -t $(NAME):$(TAG) -f ./docker/payment/Dockerfile .

test:
	GROUP=weaveworksdemos COMMIT=$(COMMIT) ./scripts/build.sh
	./test/test.sh unit.py
	./test/test.sh container.py --tag $(COMMIT)
