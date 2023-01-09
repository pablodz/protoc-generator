#!/bin/bash

echo "==========================================\n Reading build.yaml \n=========================================="
echo "[WARNING] This script is executed inside docker, don't expect working on host"
# Read the YAML file
yaml_contents=$(cat ./setup/generator.yaml)

if [ -z "$yaml_contents" ]; then
    echo "No build.yaml file found"
    exit 1
fi

echo "==========================================\n Reading environment variables from build.yaml \n=========================================="
# Extract the items array from environment and export it
keys=$(yq '.environment' ./setup/generator.yaml)

# build array
while read -r key value; do
    key=${key%\\}
    key=${key%?}
    echo "Exporting $key=$value"
    export "$key=$value"
done <<<"$keys"

echo "==========================================\n Environment variables exported \n=========================================="
printenv | grep 'PROTOGENERATOR_'

echo "==========================================\n Compiling the project... \n=========================================="
# Compile the project
list_languages=$(yq '.languages[]' ./setup/generator.yaml)

echo "[WARNING] This script is executed inside docker, don't expect working on host"
for language in $list_languages; do

    echo "Compiling for $language"
    # Extract the items array from environment and export it
    output=$(yq '.job.'$language'.output' ./setup/generator.yaml)
    echo "$language.output: $output"
    option=$(yq '.job.'$language'.options' ./setup/generator.yaml)
    echo "$language.options: $option"
    verbose=$(yq '.job.'$language'.verbose' ./setup/generator.yaml)
    echo "$language.verbose: $verbose"
    # Create output dir recursively
    mkdir -p $output
    # Build with protoc
    echo "Command: find . -name \*.proto -exec protoc $option $1 {} \;"
    find . -name \*.proto -exec protoc $option $1 {} \;

    if [ ! -z "$verbose" ]; then
        echo "==========================================\n Files compiled inside container \n=========================================="
        tree -aC $output
    fi

done
