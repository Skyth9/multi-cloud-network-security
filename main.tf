module "azure" {
  source = "./modules/azure"

  naming_prefix = local.naming_prefix
  az_user       = var.az_user
  az_pass       = var.az_pass
  shared_key    = var.shared_key
}
/*
module "aws" {
    source = "./modules/aws"
}
*/