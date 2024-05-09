#!/bin/bash -e

## NOTE: paths may differ when running in a managed task. To ensure behavior is consistent between
# managed and local tasks always use these variables for the project and project type path
PROJECT_PATH=${BASE_PATH}/project
PROJECT_TYPE_PATH=${BASE_PATH}/projecttype

cd ${PROJECT_PATH}

#********** Get tfvars from SSM 1 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "/distributed_inbound/t1.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" > t1.tfvars

  #********** Get tfvars from SSM 2 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "/distributed_inbound/t2.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" > t2.tfvars

  #********** Get tfvars from SSM 3 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "/distributed_outbound/t3.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" > t3.tfvars

  #********** Get tfvars from SSM 4 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "/distributed_outbound/t4.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" > t4.tfvars

  #********** Get tfvars from SSM 5 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "/existing_service_existing_spoke/t5.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" > t5.tfvars

  #********** Get tfvars from SSM 6 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "/existing_service_existing_spoke/t6.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" > t6.tfvars

  #********** Get tfvars from SSM 7 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "/existing_service_new_spoke/t7.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" > t7.tfvars

  #********** Get tfvars from SSM 8 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "/existing_service_new_spoke/t8.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" > t8.tfvars

  #********** Get tfvars from SSM 9 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "/multi_spoke/t11.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" > t11.tfvars

    #********** Get tfvars from SSM 10 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "/multi_spoke/t12.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" > t12.tfvars

# #********** Terratest execution **********
echo "Running Terratest"
export GOPROXY=https://goproxy.io,direct
cd test
rm -f go.mod
go mod init github.com/aws-ia/terraform-project-ephemeral
go mod tidy
# Check if Terratest is already installed
if ! go list -m all | grep -q "github.com/gruntwork-io/terratest"; then
  echo "Terratest module is not installed, installing now..."
  go get github.com/gruntwork-io/terratest/modules/terraform
else
  echo "Terratest module is already installed."
fi
go test -timeout 360m
#go test -run TestDistributedArchitectureInbound distributed_architecture_inbound_test.go -timeout 70m -v
