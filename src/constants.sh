#!/bin/sh

BACKEND_DOCKER_IMAGE=vinlab/code-inventory-backend:latest
POSTGRES_DOCKER_IMAGE=vinlab/vc-inlab-cit-postgres:1.0.0
GRAFANA_DOCKER_IMAGE=vinlab/vc-inlab-cit-grafana:1.0.1
FRONTEND_DOCKER_IMAGE=vinlab/vc-inlab-cit-frontend:latest

APP='CODE INVENTORY'
App='Code Inventory'

home_dir=~/.veracode/code-inventory
assembly_dir=${home_dir}/bin
postgres_dir=${home_dir}/data/postgresql
grafana_dir=${home_dir}/grafana
code_dir=${home_dir}/code
jobs_dir=${home_dir}/jobs
