
# Resource Group

module "rg" {
  source = "./rg"
  rg_name = var.rg_name
  rg_location = var.location
  rg_tags = var.tags
}

# Networking

module "vnet" {
  source = "github.com/dnbowers/terraform_modules-maindemo/vnet"
  vnet_name = "${var.rg_name}-${var.vnet_name}"
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  vnet_address_space = var.vnet_address_space
  tags = var.tags
}

module "subnet" {
  source = "github.com/dnbowers/terraform_modules-maindemo/subnet"
  subnet_name = "${var.rg_name}-${var.vnet_name}-${var.subnet_name}"
  vnet_name = module.vnet.vnet_name
  rg_name = module.rg.rg_name
  subnet_address_prefixes = var.subnet_address_prefixes
}

module "publicip2019" {
  count = 2
  source = "github.com/dnbowers/terraform_modules-maindemo/public_ip"
  pi_name = "Win2K19-demo-publicip-${count.index}"
  allocation_method = "Static"
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  tags = var.tags
}

module "publicip2016" {
  source = "github.com/dnbowers/terraform_modules-maindemo/public_ip"
  pi_name = "Win2K16-publicip"
  allocation_method = "Static"
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  tags = var.tags
}

module "publiciprhel" {
  source = "github.com/dnbowers/terraform_modules-maindemo/public_ip"
  pi_name = "rhel76-demo-publicip"
  allocation_method = "Static"
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  tags = var.tags
}


# Workspaces

module "log_analytics" {
  source = "github.com/dnbowers/terraform_modules-maindemo/log_analytics"
  la_name = var.la_name
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  la_sku = var.la_sku
  la_retention = var.la_retention
  tags = var.tags
}

module "automation_account" {
  source = "github.com/dnbowers/terraform_modules-maindemo/automation_account"
  aa_name = var.aa_name
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  aa_sku = var.aa_sku
  la_id = module.log_analytics.la_id
  tags = var.tags
}

module "updatemanagement" {
  source = "github.com/dnbowers/terraform_modules-maindemo/updatemanagement"
  solution_name = var.um_solution_name
  location = var.location
  rg_name = var.rg_name
  la_id = module.log_analytics.la_id
  la_workspace_name = module.log_analytics.la_workspace_name
}

# Virtual Machines

module "windows_vm_2019" {
  count = 2
  source ="github.com/dnbowers/terraform_modules-maindemo/win_vm_with_la_agent"
  vm_name = "win2k19-demo-${count.index + 1}"
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  vm_size = "Standard_B2s"
  vm_user = var.admuser
  vm_pass = var.admpass
  os_sku = "2019-Datacenter"
  os_version = "latest"
  subnet_id = module.subnet.subnet_id
  publicip_id = module.publicip2019[count.index].publicip_id
  tags = var.tags
  la_workspace_id = module.log_analytics.la_workspace_id
  la_primary_shared_key = module.log_analytics.la_primary_shared_key
  la_agent_version = "1.0"
}

module "windows_vm_2016" {
  source ="github.com/dnbowers/terraform_modules-maindemo/win_vm_with_la_agent"
  vm_name = "win2k16-demo-1"
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  vm_size = "Standard_B2s"
  vm_user = var.admuser
  vm_pass = var.admpass
  os_sku = "2016-Datacenter"
  os_version = "latest"
  subnet_id = module.subnet.subnet_id
  publicip_id = module.publicip2016.publicip_id
  tags = var.tags
  la_workspace_id = module.log_analytics.la_workspace_id
  la_primary_shared_key = module.log_analytics.la_primary_shared_key
  la_agent_version = "1.0"
}

module "rhel_vm" {
  source ="github.com/dnbowers/terraform_modules-maindemo/rhel_vm_with_la_agent"
  vm_name = "cb-rhel-1"
  location = module.rg.rg_location
  rg_name = module.rg.rg_name
  vm_size = "Standard_B1s"
  vm_user = var.admuser
  vm_pass = var.admpass
  os_sku = "76-gen2"
  os_version = "latest"
  subnet_id = module.subnet.subnet_id
  publicip_id = module.publiciprhel.publicip_id
  tags = var.tags
  la_workspace_id = module.log_analytics.la_workspace_id
  la_primary_shared_key = module.log_analytics.la_primary_shared_key
  la_agent_version = "1.8"
}