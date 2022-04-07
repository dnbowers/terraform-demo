# General

location = "uksouth"

tags = {
    Environment = "Demo Environment"
    Owner = "Demo Owner"
}

# Resource Group

rg_name = "update-management-demo"

# Virtual Network

vnet_name = "vnet-demo"

vnet_address_space = ["10.69.0.0/16"]

# Subnet

subnet_name = "subnet-demo"

subnet_address_prefixes = ["10.69.1.0/24"]

# Log Analytics

la_name = "log-analytics-demo"

la_sku = "PerGB2018"

la_retention = 30

# Automation Account

aa_name = "automation-demo"

aa_sku = "Basic"

# Update Management

um_solution_name = "UpdateMgmt-demo"

# Credentials

