# Campus-terraform

This repository contains all of the IaC code for the campus online project.

## Usage

### Requirements

- Terraform v0.13.5

### Setup

To set up variables for this project, `setup.sh` must be run. This script requires four environments variables:
- RESOURCE_GROUP_NAME
- STORAGE_ACCOUNT_NAME
- KEY_SUFFIX
- CONTAINER_NAME

These variables can be found as part of the Azure storage account configuration.

Setup.sh will then create the necessary `backend.conf` files, as well as set the `ACCOUNT_KEY` to access the Terraform backend state storage container.

### Using Terraform

Once the necessary `backend.conf` files have been created, terraform commands can be run in their respective directories by appending `-backend-config=backend.conf` flag to TF commands.
