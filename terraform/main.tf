module "vpc" {
    source          = "./modules/network/vpc"

    vpc_cidr_block  = var.vpc_cidr_block
    tag_name        = var.tag_name
}

module "subnet_priv_a" {
    source              = "./modules/network/subnet"

    cidr_block          = var.subnet_priv_a_cidr_block
    availability_zone   = var.subnet_priv_a_availability_zone
    tag_name            = var.subnet_priv_a_tag_name
    vpc_id              = module.vpc.vpc_id

depends_on = [module.vpc]
}

module "subnet_priv_b" {
    source              = "./modules/network/subnet"

    cidr_block          = var.subnet_priv_b_cidr_block
    availability_zone   = var.subnet_priv_b_availability_zone
    tag_name            = var.subnet_priv_b_tag_name
    vpc_id              = module.vpc.vpc_id

depends_on = [module.vpc]
}

module "subnet_pub_a" {
    source              = "./modules/network/subnet"

    cidr_block          = var.subnet_pub_a_cidr_block
    availability_zone   = var.subnet_pub_a_availability_zone
    tag_name            = var.subnet_pub_a_tag_name
    vpc_id              = module.vpc.vpc_id
depends_on = [module.vpc]
}

module "subnet_pub_b" {
    source              = "./modules/network/subnet"

    cidr_block          = var.subnet_pub_b_cidr_block
    availability_zone   = var.subnet_pub_b_availability_zone
    tag_name            = var.subnet_pub_b_tag_name
    vpc_id              = module.vpc.vpc_id
depends_on = [module.vpc]
}

module "igw" {
    source   = "./modules/network/internet_gateway"

    vpc_id   = module.vpc.vpc_id
    tag_name = var.igw_tag_name
depends_on = [module.vpc,module.subnet_pub_a]
}

module "ngw" {
    source          = "./modules/network/nat_gateway"

    aws_subnet_id   = module.subnet_pub_a.aws_subnet_id
    tag_name        = var.ngw_tag_name
depends_on = [module.igw]
}

module "route_table_priv" {
    source      = "./modules/network/route_table"

    vpc_id      = module.vpc.vpc_id
    tag_name    = var.route_table_tag_name
    gtw_id      = module.ngw.aws_nat_gateway_id
    subnet_id_a = module.subnet_priv_a.aws_subnet_id
    subnet_id_b = module.subnet_priv_b.aws_subnet_id
depends_on = [module.ngw]
}

module "route_table_pub" {
    source      = "./modules/network/route_table"

    vpc_id      = module.vpc.vpc_id
    tag_name    = var.route_table_tag_name
    gtw_id      = module.igw.aws_igw_gateway_id
    subnet_id_a = module.subnet_pub_a.aws_subnet_id
    subnet_id_b = module.subnet_pub_b.aws_subnet_id
depends_on = [module.igw]
}