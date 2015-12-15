REPO=172.30.122.181:5000/uber

.PHONY: compile build push

compile:
	go build -ldflags "-X main.msg \"`date`\"" main.go

build: compile
	docker build -t test-pull .

push: build
	docker tag -f test-pull $(REPO)/test-pull
	docker push $(REPO)/test-pull

test:
	make push
	oc create -f test-pull.yaml
	sleep 5
	oc logs test-pull
	echo expected:
	./main
	oc delete pod test-pull
