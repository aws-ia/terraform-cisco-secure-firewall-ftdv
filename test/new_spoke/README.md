# Test setup for Centralized_Architecture_with_FMC with new spoke VPC usecase

This folder is used to deploy the resources in AWS required to run the `Centralized_Architecture_with_FMC` usecase test where a new spoke VPC will be created as part of the deployment itself and only existing Service VPC is required to be present in the user's AWS environment.

No action is required in this folder. 
When running the test `centralized_existing_service_new_spoke_test.go`, a terraform.tfvars file with appropriate values pertaining to the usecase of new spoke VPC need to be created and placed in `new_spoke` and `examples/Centralized_Architecture_with_FMC` folders.