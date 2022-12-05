#!/bin/bash

# Add Root CA cert for Vault servers
cat <<EOT > ~/vault.crt
${root_ca_cert}
EOT
sudo mv ~/vault.crt /usr/local/share/ca-certificates/vault.crt
sudo update-ca-certificates

# Install Vault command line
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update
apt-get install -y vault
