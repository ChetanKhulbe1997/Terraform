#Terraform Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}

#Provider Block
provider "aws" {
  region = "ap-south-1"
}



#Terraform State Commands

#terraform state list                                               #To list all resources in the state file
#terraform state show <resource_address>                            #To show details of a particular resource in the state file
#erraform state rm <resource_address>                               #To remove resource from state file
#terraform refresh                                                  #To refresh the state file with real infrastructure
#terraform state mv <source> <destination>                          #To move resources in the state file
#terraform state replace-provider <from> <to>                       #To replace provider in the state file
#terraform state show aws_instance.my_instance                      #To show details of a particular resource in the state file
#terraform plan -out=tfplan                                         #To save the plan to a file
#terraform apply "tfplan"                                           #To apply the saved plan file
#terraform validate                                                 #To validate the terraform files for syntax errors
#terraform import <resource_address> <unique_id>                    #To import existing resources to state file
