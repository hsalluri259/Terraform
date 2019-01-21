#--- networking/main.tf ---
data "aws_availability_zones" "available" {}

#Create a vpc
resource "aws_vpc" "tf_vpc" {
    cidr_block = "${var.cidr_block}"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags {
        Name = "tf_vpc"
    }
}

#Create an Internet gateway resource
resource "aws_internet_gateway" "tf_internet_gateway" {
    vpc_id = "${aws_vpc.tf_vpc.id}"
    tags {
        Name = "tf_igw"
    }
}
#Create a route table
resource "aws_route_table" "tf_public_rt" {
    vpc_id = "${aws_vpc.tf_vpc.id}"
    
    route {
        gateway_id = "${aws_internet_gateway.tf_internet_gateway.id}"
        cidr_block = "0.0.0.0/0"
    }
    tags {
        Name = "tf_public"
    }
}

#Creating Private route table
resource "aws_default_route_table" "tf_private_rt" {
    default_route_table_id = "${aws_vpc.tf_vpc.default_route_table_id}"
    
    tags {
        Name = "tf_private"
    }
}