SHELL := /bin/bash
CONTAINER_BUILDER_NAME=protoc-generator
BASE_PROTOS=/protos/v1/

.PHONY: env
env:
	printenv

.PHONY: clean
clean:
	yq eval '.job.*.output' ./setup/generator.yaml | xargs -I {} rm -rf {}


.PHONY: build
generate: clean
	echo "========Remove protoc generator image========"
	docker rm ${CONTAINER_BUILDER_NAME} 2>&1 > /dev/null || true
	
	echo "========Building protoc generator image========"
	build_args="" 
	yq eval '.environment' ./setup/generator.yaml | \
	while read -r key value; do \
		key=$${key%\\}; \
		key=$${key%?}; \
		echo "--build-arg $$key=$$value";\
		build_args="$$build_args --build-arg $$key=$$value"; \
	done

	docker build \
		--file ./setup/Dockerfile \
		$${build_args} \
		-t ${CONTAINER_BUILDER_NAME} .

	
	
	echo "========Running protoc generator image========"
	docker run --name ${CONTAINER_BUILDER_NAME} ${CONTAINER_BUILDER_NAME}

	echo "========Loading envs========"

	echo "========Building protoc generator image========"
	yq eval '.environment' ./setup/generator.yaml | \
	while read -r key value; do \
		key=$${key%\\}; \
		key=$${key%?}; \
		echo "export $$key=$$value";\
	done
	echo "========Copying generated files========"
	yq eval '.job.*.output' ./setup/generator.yaml | cut -c 2- | xargs -I {} \
		mkdir -p .{}/v1/
	yq eval '.job.*.output' ./setup/generator.yaml | cut -c 2- | xargs -I {} \
		docker cp ${CONTAINER_BUILDER_NAME}:${PG_DOCKERFILE_WORKDIR}{}${BASE_PROTOS} .{}/
	
	echo "Updating go.mod if exists in HOST"
	go mod tidy  2>&1 > /dev/null || true
