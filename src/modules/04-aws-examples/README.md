# Azure Examples

## Beispiel

`aws.tf`
```terraform
provider "aws" {
    version = "~> 2.65"
    region  = "us-west-2"
}

# 65,536 IP addresses
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
}

# 256 IP addresses
resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.0.0/24"
}
```

## Links

---
[5. Resource Exports & Dependencies](05_Resource_Exports_and_Dependencies.md) &ensp;|&ensp; [Table of Contents](00_Overview.md) &ensp;|&ensp; [7. Input Variables in Terraform](07_Input_Variables_in_Terraform.md)
