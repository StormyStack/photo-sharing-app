module "networking" {
  source = "./modules/networking"
  availability_zones = var.availability_zones
  default_route_table_id = module.networking.default_route_table_id
}

module "storage" {
  source = "./modules/storage"
  bucket_name = var.bucket_name
}

module "database" {
  source = "./modules/database"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.networking.main_vpc_id
  my-ip = var.my-ip
  s3_bucket_arn = module.storage.s3_bucket_arn
  dynamodb_arn = module.database.dynamodb_arn
}

module "load_balancer" {
  source = "./modules/load_balancer"
  public_subnet_ids = module.networking.public_subnet_ids
  vpc_id = module.networking.main_vpc_id
}

module "webserver" {
  source = "./modules/webserver"
  subnet_ids = module.networking.public_subnet_ids
  ec2_sg_id = module.security.ec2-ag_id
  ec2_iam_profile_name = module.security.ec2_iam_profile_name
  alb_target_group_arn = module.load_balancer.alb_target_group_arn
  
  depends_on = [
    module.networking,
    module.storage,
    module.database,
    module.security,
    module.load_balancer
  ]
}
