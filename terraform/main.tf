module "networking" {
  source = "./modules/networking"
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
  eb_sg_id = module.security.eb_sg_id
  beanstalk_iam_profile_name = module.security.beanstalk_iam_profile_name
  vpc_id = module.networking.main_vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  public_subnet_ids = module.networking.public_subnet_ids
  s3_bucket_name = var.bucket_name
  dynamodb_table_name = module.database.dynamodb_table_name
  app_version = var.app_version
  s3_object_key = module.app_storage.s3_object_key
  app_bucket_name = var.app_bucket_name
  photo_app_version_description = var.photo_app_version_description
  
  depends_on = [ module.security ]
}