SBCL_VERSION = $(shell cat VERSION_SBCL.txt)
QUICKLISP_VERSION = $(shell cat VERSION_QUICKLISP.txt)

app_dir := $(dir $(CURDIR))

.PHONY: cl-container
cl-container: Dockerfile
	docker build -t leytzher/cl-container:$(QUICKLISP_VERSION) \
		--build-arg SBCL_VERSION=$(SBCL_VERSION) \
		--build-arg QUICKLISP_VERSION=$(QUICKLISP_VERSION) .

run: cl-container
	sudo docker run -a stdin -a stdout -a stderr -i -t leytzher/cl-container:$(QUICKLISP_VERSION)

clean:
	sudo docker rm $(docker ps -a -q)
	sudo docker rmi $(docker images -q)
