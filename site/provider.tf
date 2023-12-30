terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31.0"
    }
  }
#  backend "s3" {
#    bucket         = "ecs-terraform-examplecom-state"
#    key            = "example/com.tfstate"
#    region         = "eu-west-1"
#    encrypt        = "true"
#    dynamodb_table = "ecs-terraform-remote-state-dynamodb"
#  }
}

provider "aws" {
  region = local.region
}
