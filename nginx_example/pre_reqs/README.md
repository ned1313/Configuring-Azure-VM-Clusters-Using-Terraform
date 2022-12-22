# Prerequisites

We are going to create the networking resources for the NGINX cluster.

## Deploying the Prerequisites

We are using the Azure CLI for authentication and deployment. You can find the Azure CLI [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest).

```bash
az login
az account set -s "SUBSCRIPTION_NAME"
```

Once you are logged in, you can deploy the prerequisites. First make a copy of the `terraform.tfvars.example` file and rename it to `terraform.tfvars`. Then edit the file and fill in the values for the variables.

Once your `terraform.tfvars` file is ready, you can deploy the resources:

```bash
terraform init
terraform apply -auto-approve
```

Make note of the outputs, as you will need them to deploy NGINX.
