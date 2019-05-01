# Docker build Code Inventory Assembly
#
# Usage:
# Build locally
#   cd [project]
#   docker build -t vinlab/vc-inlab-cit-assembly:latest .
# Run once - this will create Code Inventory home dir and the required dir structure underneath:
# docker run \
#   --rm \
#   --volume ~/.veracode/code-inventory/bin:/var/bin \
#   --volume ~/.veracode/code-inventory/data/postgresql:/var/postgresql \
#   --volume ~/.veracode/code-inventory/grafana/data:/var/grafana \
#   --volume ~/.veracode/code-inventory/code:/var/code \
#   --volume ~/.veracode/code-inventory/jobs:/var/jobs \
#   vinlab/vc-inlab-cit-assembly:latest
#
# Suitable for Docker Hub automated builds.
# Setup:
#   Specify this Dockerfile in Docker Hub build settings:
#   Dockerfile location: Dockerfile.
# Pull resulting docker image to local:
#   docker login
#   docker pull vinlab/code-inventory-assembly
# Run once - this will create Code Inventory home dir and the required dir structure underneath:
#   [run the 'docker run' command shown above]
#
# Code Inventory is now located in ~/.veracode/code-inventory
# Code Inventory's start/stop scripts are in ~/.veracode/code-inventory/bin
#
# Author: Andrey Potekhin
#
FROM alpine:3.9.3

RUN mkdir -p /var/bin
RUN mkdir -p /var/postgresql
RUN mkdir -p /var/grafana
RUN mkdir -p /var/code
RUN mkdir -p /var/jobs

ADD ./lib /var/bin/lib
ADD ./src /var/bin/src
ADD *.yml /var/bin/
ADD *.sh /var/bin/
ADD *.md /var/bin/
