#!/bin/bash

YAML_DIR="path/to/your/yaml/files"

read -p "Are the images stored locally? (y/n): " is_local

DOCKER_HUB_USER=""

if [ "$is_local" != "y" ]; then
    read -p "Enter your Docker Hub username: " DOCKER_HUB_USER
fi

# Find all *-deployment.yaml files and update the image line
# find "$YAML_DIR" -type f -name "*-deployment.yaml" -print0 | while IFS= read -r -d '' file; do
find "$YAML_DIR" -type f -name "*-deployment.yaml" ! -name "memcached-*-deployment.yaml" ! -name "mongodb-*-deployment.yaml" -print0 | while IFS= read -r -d '' file; do
    # Extract the service name from the filename
    service_name=$(basename "$file" | sed 's/-deployment\.yaml//')
    
    if [ "$is_local" = "y" ]; then
        # Update the image line for local images, only if it matches the specific pattern
        sed -i '/image: deathstarbench\/hotel-reservation:latest/c\          image: '"${service_name}"':latest' "$file"
    else
        # Update the image line for Docker Hub images, only if it matches the specific pattern
        sed -i '/image: deathstarbench\/hotel-reservation:latest/c\          image: '"${DOCKER_HUB_USER}/${service_name}"':latest' "$file"
    fi
    
    # Check if any changes were made
    if [ -n "$(sed -n '/image: deathstarbench\/hotel-reservation:latest/p' "$file")" ]; then
        echo "No changes made to $file (pattern not found)"
    else
        echo "Updated $file"
    fi
done