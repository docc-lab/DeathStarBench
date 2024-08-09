#!/bin/bash

YAML_DIR="/local/DeathStarBench/hotelReservation/kubernetes"

read -p "Are the images stored locally? (y/n): " is_local
DOCKER_HUB_USER=""
ALL_IN_ONE_IMAGE=""

if [ "$is_local" != "y" ]; then
    read -p "Enter your Docker Hub username: " DOCKER_HUB_USER
fi

read -p "Do all services use the same all-in-one image? (y/n): " use_all_in_one

if [ "$use_all_in_one" = "y" ]; then
    read -p "Enter the all-in-one image name: " ALL_IN_ONE_IMAGE
fi

# Find all *-deployment.yaml files (excluding memcached-* and mongodb-*) and update the image line
find "$YAML_DIR" -type f -name "*-deployment.yaml" ! -name "memcached-*-deployment.yaml" ! -name "mongodb-*-deployment.yaml" -print0 | while IFS= read -r -d '' file; do
    # Extract the service name from the filename
    service_name=$(basename "$file" | sed 's/-deployment\.yaml//')
    
    # Determine the image name to use
    if [ "$use_all_in_one" = "y" ]; then
        image_name="${ALL_IN_ONE_IMAGE}"
    else
        image_name="${service_name}"
    fi
    
    if [ "$is_local" = "y" ]; then
        # Update the image line for local images
        sed -i '/image: deathstarbench\/hotel-reservation:latest/c\          image: '"${image_name}"':latest' "$file"
    else
        # Update the image line for Docker Hub images
        sed -i '/image: deathstarbench\/hotel-reservation:latest/c\          image: '"${DOCKER_HUB_USER}/${image_name}"':latest' "$file"
    fi
    
    # Check if any changes were made
    if [ -n "$(sed -n '/image: deathstarbench\/hotel-reservation:latest/p' "$file")" ]; then
        echo "No changes made to $file (pattern not found)"
    else
        echo "Updated $file"
    fi
done