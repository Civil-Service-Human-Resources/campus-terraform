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

#### Backend config

Once the necessary `backend.conf` files have been created, `terraform init -backend-config=backend.conf` can be run in the required repository. All following Terraform commands will then use the correct remote state.

#### Azure credentials

The following Azure credentials must be set (as tf variables) for Terraform to manage resources (Aka. the deploy user):
- sub_id
- client_id
- client_secret
- tenant_id

If these values are left blank, Terraform will get them from the currently logged in user's CLI session.

**IMPORTANT**: If using the CLI, remember to use the correct Subscription. 
