# NSG for US-Production-Web-Server-VM

az network nsg create \
  --resource-group RG-US-Deployment \
  --name NSG-US-Production-Web-Server-VM

az network nsg rule create \
  --resource-group RG-US-Deployment \
  --name NSG-US-Production-Web-Server-VM-ALLOW-HTTP \
  --nsg-name NSG-US-Production-Web-Server-VM \
  --protocol tcp \
  --direction inbound \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix 'VirtualNetwork' \
  --destination-port-range 80 \
  --access allow \
  --priority 200

az network nsg rule create \
  --resource-group RG-US-Deployment \
  --name NSG-US-Production-Web-Server-VM-ALLOW-SSH \
  --nsg-name NSG-US-Production-Web-Server-VM\
  --protocol tcp \
  --direction inbound \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix 'VirtualNetwork' \
  --destination-port-range 22 \
  --access allow \
  --priority 100

# Deploy US-Production-Web-Server-VM

az vm create \
  --resource-group RG-US-Deployment \
  --name US-Production-Web-Server-VM \
  --admin-username adminuser \
  --admin-password adminadmin123! \
  --image UbuntuLTS \
  --vnet-name US-Production-vNET \
  --nsg NSG-US-Production-Web-Server-VM \
  --subnet PROD-Subnet-1

az vm extension set \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --name CustomScript \
  --vm-name US-Production-Web-Server-VM \
  --resource-group RG-US-Deployment \
  --settings '{"commandToExecute":"apt-get -y update && apt-get -y install apache2 && rm -rf /var/www/html && git clone https://github.com/XaaSTechnologies/LOA11-Azure-App-Service.git /var/www/html/"}'
