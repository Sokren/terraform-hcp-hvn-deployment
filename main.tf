terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.21.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.71.0"
    }
  }
}

// Configure the provider

provider "aws" {
  region = var.aws_region
}

// Create a HashiCorp Virtual Network (HVN).
resource "hcp_hvn" "hvn" {
  hvn_id         = var.hvn_id
  cloud_provider = "aws"
  region         = var.aws_region
  cidr_block     = var.hvn_cidr_block
}

// Create an HCP network peering to peer your HVN with your AWS VPC.
resource "hcp_aws_network_peering" "hcp_network_peering" {
  peering_id          = var.peer_id
  hvn_id              = hcp_hvn.hvn.hvn_id
  peer_vpc_id         = var.aws_vpc_id
  peer_account_id     = var.aws_vpc_owner_id
  peer_vpc_region     = var.aws_region
  depends_on = [
    hcp_hvn.hvn,
  ]
}

// Create an HVN route that targets your HCP network peering and matches your AWS VPC's CIDR block.
resource "hcp_hvn_route" "hcp_route" {
  hvn_link         = hcp_hvn.hvn.self_link
  hvn_route_id     = var.hvn_route_id
  destination_cidr = var.aws_vpc_cidr_block
  target_link      = hcp_aws_network_peering.hcp_network_peering.self_link
}

// Accept the VPC peering within your AWS account.
resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = hcp_aws_network_peering.hcp_network_peering.provider_peering_id
  auto_accept               = true
}

output "hvn_id" {
  description = "value of the hvn ID to create clusters"
  value = hcp_hvn.hvn.hvn_id
}
output "hcp_aws_network_peering_id" {
  description = "value of the peering ID to use it to connect subnets"
  value = hcp_aws_network_peering.hcp_network_peering.provider_peering_id
}