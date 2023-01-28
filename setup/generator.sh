#!/bin/bash

printf "\n========================================= Reading build.yaml =========================================\n";
printf "[WARNING] This script is executed inside docker, don't expect working on host";
# Read the YAML file
yaml_contents=$(cat ./setup/generator.yaml)

if [ -z "$yaml_contents" ]; then
    printf "No build.yaml file found"
    exit 1
fi

printf "\n========================================= Reading environment variables from build.yaml =========================================\n";
# Extract the items array from environment and export it
keys=$(yq '.environment' ./setup/generator.yaml)

# build array
while read -r key value; do
    key=${key%\\}
    key=${key%?}
    printf "Exporting %s=%s" "$key" "$value"
    export "$key=$value"
done <<<"$keys"

printf "\n========================================= Environment variables exported =========================================\n";
printenv | grep 'PROTOGENERATOR_'

printf "\n========================================= Compiling the project... =========================================\n";

# Compile the project
list_languages=$(yq '.languages[]' ./setup/generator.yaml)

printf "\n[WARNING] This script is executed inside docker, don't expect working on host\n";
for language in $list_languages; do

    printf "Compiling for %s\n" "$language"
    # Extract the items array from environment and export it
    output=$(yq '.job.'$language'.output' ./setup/generator.yaml)
    printf "%s.output: %s" "$language" "$output"
    option=$(yq '.job.'$language'.options' ./setup/generator.yaml)
    printf "%s.options: %s" "$language" "$option"
    verbose=$(yq '.job.'$language'.verbose' ./setup/generator.yaml)
    printf "%s.verbose: %s" "$language" "$verbose"
    # Create output dir recursively
    mkdir -p $output
    # Build with protoc
    echo "Command: find . -name \*.proto -exec protoc $option $1 {} \;  \n";
    find . -name \*.proto -exec protoc $option $1 {} \;

    if [ ! -z "$verbose" ]; then
        printf "\n========================================= Files compiled inside container =========================================\n";
        tree -aC $output
    fi

done
