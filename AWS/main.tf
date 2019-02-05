#----provide providers name in Root/main.tf ----
provider "aws" {
  region = "${var.aws_region}"
}
/*
#Create a backend
terraform {
  backend "s3" {
    bucket = "hs123-terraform-state"
    key = "terraform/terraform.tfstate"
    region = "us-west-2"
  }
}*/
#Deploy storage resource
module "storage" {
  source       = "./storage"
  project_name = "${var.project_name}"
}

#Deploy networking module
module "networking" {
  source       = "./networking"
  vpc_cidr     = "${var.vpc_cidr}"
  public_cidrs = "${var.public_cidrs}"
  accessip     = "${var.accessip}"
}

#Deploy compute module
module "compute" {
  source          = "./compute"
  key_name        = "${var.key_name}"
  public_key_path = "${var.public_key_path}"
  instance_type   = "${var.server_instance_type}"
  instance_count  = "${var.instance_count}"
  subnets         = "${module.networking.public_subnets}"
  security_group  = "${module.networking.public_sg}"
  subnet_ips      = "${module.networking.subnet_ips}"
}
