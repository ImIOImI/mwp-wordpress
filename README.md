# Simple Wordpress Site
This is a pretty basic config for a wordpress site that uses an AWS EC2 autoscalling group instance, an application load 
balancer to route traffic and a mariadb rds instance as the backend database. 

## Setup

This setup assumes that you already have a Terraform user that you can use locally with admin privileges

1) Navigate to `remote-state` and execute `terraform init && terraform apply`
2) Either register a domain in AWS and pass that domain in via the variables, or disable route 53 in the variables and 
use the ALB dns name for this demo
3) Navigate to `site` and execute `terraform init && terraform apply`
