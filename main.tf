module "azure" {
    source = "./modules/azure"

    naming_prefix = local.naming_prefix
}

module "aws" {
    source = "./modules/aws"
}
