# Test setup for multiple_spoke_with_fmc usecase

This folder is used to deploy the resources in AWS required to run the `multiple_spoke_with_fmc` usecase test.

No action is required in this folder. 
When running the test `multi_spoke_test.go`, a terraform.tfvars file with appropriate values pertaining to the usecase of new spoke VPC need to be created and placed in `multi_spoke` and `examples/multiple_spoke_with_fmc` folders.