SHELL := /bin/bash
CONTAINER_BUILDER_NAME=protoc-generator
BASE_PROTOS=/protos/v1/

-include ./setup/.env

.PHONY: env
env:
	printenv

.PHONY: clean
clean:
	yq eval '.job.*.output' ./setup/generator.yaml | xargs -I {} rm -rf {}

loadenvs:
	printf "\n========Loading envs========\n";
	rm -rf ./setup/.env 2>&1 > /dev/null || true
	yq eval '.environment' ./setup/generator.yaml | \
		while read -r key value; do \
			key=$${key%\\}; \
			key=$${key%?}; \
			echo "export $$key=$$value" >> ./setup/.env; \
		done;

.PHONY: build
generate: loadenvs clean
	printf "\n========Remove protoc generator image========\n";
	docker rm ${CONTAINER_BUILDER_NAME} 2>&1 > /dev/null || true
	
	printf "\n========Building protoc generator image========\n";
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

	
	
	printf "\n========Running protoc generator image========\n";
	docker run --name ${CONTAINER_BUILDER_NAME} ${CONTAINER_BUILDER_NAME}

	printf "\n========Copying generated files========\n";
	yq eval '.job.*.output' ./setup/generator.yaml | \
		cut -c 2- | \
		xargs -I {} \
		mkdir -p .{}/v1/
	yq eval '.job.*.output' ./setup/generator.yaml | \
		cut -c 2- | \
		xargs -I {} \
		docker cp ${CONTAINER_BUILDER_NAME}:${PG_DOCKERFILE_WORKDIR}{}${BASE_PROTOS} .{}/
	
	printf "\nUpdating go.mod if exists in HOST\n";
	go mod tidy  2>&1 > /dev/null || true
