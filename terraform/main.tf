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

module "eks_cluster" {
    source           =  "./modules/cluster"

    cluster_name     = var.cluster_name
    cluster_role_arn = var.cluster_role_arn
    cluster_version  = var.cluster_version
    subnet_id_a      = module.subnet_pub_a.aws_subnet_id
    subnet_id_b      = module.subnet_pub_b.aws_subnet_id
depends_on = [ module.route_table_pub ]
}

module "eks_node_group" {
    source              =  "./modules/cluster/node_pool"

    node_role_arn       = var.node_role_arn
    node_group_name     = var.node_group_name
    cluster_name        = var.cluster_name
    node_group_version  = var.node_group_version
    subnet_ids          = [module.subnet_priv_a.aws_subnet_id,module.subnet_priv_b.aws_subnet_id]
    capacity_type       = var.node_group_capacity_type
    instance_types      = var.node_group_instance_types

depends_on = [ module.eks_cluster ]
}

module "db_subnet_group_name" {
    source = "./modules/database/rds/db_subnet_group"

    db_subnet_group_name = var.db_subnet_group_name
    db_subnet_group      = [module.subnet_priv_a.aws_subnet_id,module.subnet_priv_b.aws_subnet_id]

depends_on = [ module.route_table_priv ]
}

module "auth_service_db" {
    source                  = "./modules/database/rds/postgresql"
    allocated_storage       = var.auth_service_allocated_storage
    identifier              = var.auth_service_identifier
    db_name                 = var.auth_service_db_name
    engine                  = var.auth_service_engine
    engine_version          = var.auth_service_engine_version
    instance_class          = var.auth_service_instance_class
    username                = var.auth_service_username
    password                = var.auth_service_password
    availability_zone       = var.auth_service_availability_zone
    db_subnet_group_name    = var.db_subnet_group_name
    storage_type            = var.auth_service_storage_type
    vpc_security_group_ids  = var.auth_service_db_vpc_security_group_ids 
depends_on = [ module.db_subnet_group_name ]
}

module "flag_service_db" {
    source                  = "./modules/database/rds/postgresql"
    allocated_storage       = var.flag_service_allocated_storage
    identifier              = var.flag_service_identifier
    db_name                 = var.flag_service_db_name
    engine                  = var.flag_service_engine
    engine_version          = var.flag_service_engine_version
    instance_class          = var.flag_service_instance_class
    username                = var.flag_service_username
    password                = var.flag_service_password
    availability_zone       = var.flag_service_availability_zone
    db_subnet_group_name    = var.db_subnet_group_name
    storage_type            = var.flag_service_storage_type
    vpc_security_group_ids  = var.flag_service_db_vpc_security_group_ids 
depends_on = [ module.db_subnet_group_name ]
}

module "targeting_service_db" {
    source                  = "./modules/database/rds/postgresql"
    allocated_storage       = var.targeting_service_allocated_storage
    identifier              = var.targeting_service_identifier
    db_name                 = var.targeting_service_db_name
    engine                  = var.targeting_service_engine
    engine_version          = var.targeting_service_engine_version
    instance_class          = var.targeting_service_instance_class
    username                = var.targeting_service_username
    password                = var.targeting_service_password
    availability_zone       = var.targeting_service_availability_zone
    db_subnet_group_name    = var.db_subnet_group_name
    storage_type            = var.targeting_service_storage_type
    vpc_security_group_ids  = var.targeting_service_db_vpc_security_group_ids 
depends_on = [ module.db_subnet_group_name ]
}
