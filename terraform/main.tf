module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "rds" {
  source        = "./modules/rds"
  project_name  = var.project_name
  db_username   = var.db_username
  db_password   = var.db_password
  db_subnet_ids = module.vpc.db_subnet_ids
  db_sg_id      = module.sg.db_sg_id
}