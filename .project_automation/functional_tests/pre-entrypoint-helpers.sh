#!/bin/bash -e

## NOTE: paths may differ when running in a managed task. To ensure behavior is consistent between
# managed and local tasks always use these variables for the project and project type path
PROJECT_PATH=${BASE_PATH}/project
PROJECT_TYPE_PATH=${BASE_PATH}/projecttype

echo "Starting Functional Tests"

cd ${PROJECT_PATH}

#********** TFC Env Vars *************
# export AWS_DEFAULT_REGION=us-east-1
# export TFE_TOKEN=`aws secretsmanager get-secret-value --secret-id abp/tfc/token | jq -r ".SecretString"`
# export TF_TOKEN_app_terraform_io=`aws secretsmanager get-secret-value --secret-id abp/tfc/token | jq -r ".SecretString"`

#********** MAKEFILE *************
echo "Build the lambda function packages"
make all

#********** Get tfvars from SSM 1 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "distributed_inbound/t1.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" >> t1.tfvars

  #********** Get tfvars from SSM 2 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "distributed_inbound/t2.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" >> t2.tfvars

  #********** Get tfvars from SSM 3 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "distributed_outbound/t3.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" >> t3.tfvars

  #********** Get tfvars from SSM 4 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "distributed_outbound/t4.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" >> t4.tfvars

  #********** Get tfvars from SSM 5 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "existing_service_existing_spoke/t5.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" >> t5.tfvars

  #********** Get tfvars from SSM 6 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "existing_service_existing_spoke/t6.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" >> t6.tfvars

  #********** Get tfvars from SSM 7 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "existing_service_new_spoke/t7.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" >> t7.tfvars

  #********** Get tfvars from SSM 8 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "existing_service_new_spoke/t8.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" >> t8.tfvars

  #********** Get tfvars from SSM 9 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "multi_spoke/t11.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" >> t11.tfvars

    #********** Get tfvars from SSM 10 *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "multi_spoke/t12.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" >> t12.tfvars

# #********** Checkov Analysis *************
# echo "Running Checkov Analysis on root module"
# checkov --directory . --skip-path examples --framework terraform

# echo "Running Checkov Analysis on terraform plan"
# terraform init
# terraform plan -out tf.plan -var-file functional_test.tfvars
# terraform show -json tf.plan  > tf.json 
# checkov 

# #********** Terratest execution **********
echo "Running Terratest"
export GOPROXY=https://goproxy.io,direct
cd test
rm -f go.mod
go mod init github.com/aws-ia/terraform-project-ephemeral
go mod tidy
go install github.com/gruntwork-io/terratest/modules/terraform
go test -timeout 45m

#********** CLEANUP *************
echo "Cleaning up all temp files and artifacts"
cd ${PROJECT_PATH}
make clean

echo "End of Functional Tests"