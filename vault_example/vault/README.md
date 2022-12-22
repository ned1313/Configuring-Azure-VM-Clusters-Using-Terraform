# Deploying Vault

This section walks you through using the pre-requisite resources to deploy and configure Vault.

## Deploying with Terraform

You will need values from the pre-requisite resources to deploy Vault. You can find the values in the outputs of the pre-requisite resources.

Make a copy of the `terraform.tfvars.example` file and rename it to `terraform.tfvars`. Then edit the file and fill in the values for the variables.

Once your `terraform.tfvars` file is ready, you can deploy the resources:

```bash
terraform init
terraform apply -auto-approve
```

The output from the deployment will be used in the post deployment actions.

## Post Deployment Actions

Connect to the proxy VM using SSH and the username and password specified in the terraform.tfvars files for your prerequisite resources.

```bash
ssh proxyadmin@PROXY_IP_ADDRESS
```

You are going to initalize the Vault cluster by issuing commands to the first Vault node.

```bash
export VAULT_ADDR=https://FIRST_NODE_IP_ADDRESS:8200
export VAULT_SKIP_VERIFY=true

vault operator init -key-shares=3 -key-threshold=2
```

Copy the output of the command and save it in a secure location. You will need it to unseal the Vault cluster.

```bash
vault operator unseal
```

Repeat the unseal command for the remaining two nodes.

```bash
export VAULT_ADDR=https://SECOND_NODE_IP_ADDRESS:8200
vault operator unseal

export VAULT_ADDR=https://THIRD_NODE_IP_ADDRESS:8200
vault operator unseal
```

Switch to the load balancer IP address and login to Vault.

```bash
echo "LOAD_BALANCER_IP_ADDRESS FQDN_OF_VAULT" | sudo tee -a /etc/hosts
export VAULT_ADDR=https://FQDN_OF_VAULT # Note we are using port 443 for the load balancer

vault status

vault login # Use the root token from the init command
```
