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

module "app_storage" {
  source = "./modules/app_storage"
  app_bucket_name = var.app_bucket_name
  app_zip_path = var.app_zip_path
}

module "beanstalk" {
  source = "./modules/beanstalk"
  subnet_ids = module.networking.public_subnet_ids
  eb_sg_id = module.security.eb_sg_id
  beanstalk_iam_profile_name = module.security.beanstalk_iam_profile_name
  my_alb_arn = module.load_balancer.my_alb_arn
  s3_bucket_name = module.storage.s3_bucket_name
  dynamodb_table_name = module.database.dynamodb_table_name
  s3_object_key = module.app_storage.s3_object_key
  app_bucket_name = var.app_bucket_name
  app_version = var.app_version
  my_alb_name = module.load_balancer.my_alb_name
}

module "load_balancer" {
  source = "./modules/load_balancer"
  public_subnet_ids = module.networking.public_subnet_ids
  alb_sg_id = module.security.alb_sg_id
  vpc_id = module.networking.main_vpc_id
}