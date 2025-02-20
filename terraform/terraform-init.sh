#!/bin/bash

# Check if running in GitLab CI/CD
if [ -n "$CI_JOB_TOKEN" ]; then
  echo "Using remote GitLab backend..."
  export TF_CLI_ARGS_init="-backend-config=backend-gitlab.tfvars"
else
  echo "Using local backend..."
  export TF_CLI_ARGS_init=""
fi

terraform init