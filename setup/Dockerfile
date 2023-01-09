ARG PG_PROTOC_VERSION=${PG_PROTOC_VERSION:-3.3.0}
ARG PG_DOCKERFILE_WORKDIR=${PG_DOCKERFILE_WORKDIR:-/generator}
ARG PG_DOCKERFILE_CONTEXT=${PG_DOCKERFILE_CONTEXT:-./setup}
ARG PG_GENERATORSCRIPT=${PG_GENERATORSCRIPT:-./setup/generator.sh}

FROM --platform=linux/amd64 golang:1.19-buster

# STABLE VOZY
ARG PG_PROTOC_VERSION
ARG PG_DOCKERFILE_WORKDIR
ARG PG_DOCKERFILE_CONTEXT
ARG PG_GENERATORSCRIPT
ARG DEBIAN_FRONTEND=noninteractive 

# Install dependencies
RUN apt-get update &&\
    apt-get -y install \
    unzip \
    tree \
    grep


RUN printenv | grep PG

# Install yq
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq

# Install protoc and plugins
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v${PG_PROTOC_VERSION}/protoc-${PG_PROTOC_VERSION}-linux-x86_64.zip -O protoc.zip &&\
    unzip protoc.zip &&\
    mv bin/protoc /usr/local/bin/protoc &&\
    mkdir -p /usr/local/include/google/protobuf &&\
    mv include/google/protobuf /usr/local/include/google/ &&\
    tree /usr/local/include/google &&\
    rm -rf protoc.zip

# Download plugins compiled to export for all languages
RUN wget https://github.com/pablodz/grpc_plugins/releases/download/v1.0.0/grpc_plugins.zip -O /grpc_plugins.zip ;\
    unzip  /grpc_plugins.zip -d /grpc_plugins ;\
    cp /grpc_plugins/* /usr/local/bin/

# Install golang compiler and plugin injector
RUN go install -v github.com/golang/protobuf/protoc-gen-go@v1.5.2

# Create dir and copy files
WORKDIR ${PG_DOCKERFILE_WORKDIR}
COPY . .
# Run compiler
RUN tree -L 3 .; \
    chmod +x ${PG_DOCKERFILE_CONTEXT}/* ;\
    ${PG_GENERATORSCRIPT}
