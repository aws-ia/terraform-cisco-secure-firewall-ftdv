# Test setup for Centralized_Architecture_with_FMC with existing spoke VPC usecase

This folder is used to deploy the resources in AWS required to run the `Centralized_Architecture_with_FMC` usecase test where the prerequiste is that both the service and spoke VPC should already be present in the user AWS environment.

No action is required in this folder. 
When running the test `centralized_existing_service_existing_spoke_test.go`, a terraform.tfvars file with appropriate values pertaining to the usecase of existing spoke VPC need to be created and placed in `existing_spoke` and `examples/Centralized_Architecture_with_FMC` folders.