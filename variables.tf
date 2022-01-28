variable "aws_vpc_id" {
  type = string
  description = "ID of the VPC to create peering"
}
variable "aws_vpc_owner_id" {
  type = string
  description = "ID of the owner's VPC to create peering"
}
variable "aws_vpc_cidr_block" {
  type = string
  description = "VPC cidr block destination"
}
variable "aws_region" {
  type = string
  description = "Location of the Region to deploy"
  default = "eu-west-1"
}
variable "hvn_id" {
  type = string
  description = "Name of the hvn"
  default = "demo-hvn"
}
variable "hvn_cidr_block" {
  type = string
  description = "CIDR for the HVN"
  default = "172.25.16.0/20"
}
variable "peer_id" {
  type = string
  description = "Name of the peer"
  default = "peering"
}
variable "hvn_route_id" {
  type = string
  description = "Name of the hvn route"
  default = "peer-route-id"
}