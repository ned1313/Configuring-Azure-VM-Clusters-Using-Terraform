# Deploying NGINX

This section walks you through using the pre-requisite resources to deploy and configure NGINX.

## Deploying with Terraform

You will need values from the pre-requisite resources to deploy NGINX. You can find the values in the outputs of the pre-requisite resources.

Make a copy of the `terraform.tfvars.example` file and rename it to `terraform.tfvars`. Then edit the file and fill in the values for the variables.

Once your `terraform.tfvars` file is ready, you can deploy the resources:

```bash
terraform init
terraform apply -auto-approve
```

The output from a successful deployment will include the FQDN of the load balancer. Connect to the load balancer using a web browser and you should see the index.html page that was generated and placed on the NFS share.
